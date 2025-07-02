require "httparty"

class DomainsController < ApplicationController
  before_action :set_domain, only: [ :show, :destroy, :start_scan ]

  def index
    @domains = Current.session.user.domains.order(created_at: :desc)
    @domain = Domain.new
  end

  def show
    # @domain is set by before_action
    respond_to do |format|
      format.html
      format.turbo_stream { render "show", locals: { domain: @domain } }
    end
  end

  def create
    @domain = Current.session.user.domains.build(domain_params)
    respond_to do |format|
      if @domain.save
        format.turbo_stream # renders create.turbo_stream.erb
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @domain.destroy
  end

  def start_scan
    # Create enumeration scan
    enum_scan = @domain.enumeration_scans.build(
      user: Current.session.user,
      status: "pending"
    )

    # Create vulnerability scan
    vuln_scan = @domain.vulnerability_scans.build(
      user: Current.session.user,
      status: "pending"
    )

    respond_to do |format|
      if enum_scan.save && vuln_scan.save
        # Trigger unified API request
        notify_api_about_scan(enum_scan.id, vuln_scan.id)
        format.turbo_stream
      else
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_domain
      @domain = Current.session.user.domains.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, alert: "Domain not found."
    end

    def domain_params
      params.require(:domain).permit(:domain)
    end

    def notify_api_about_scan(enum_scan_id, vuln_scan_id)
      api_key = Rails.application.credentials.dig(:api_key)
      url = "https://asm-durable-function.azurewebsites.net/api/orchestrators/start_scan?code=#{api_key}"

      if api_key.present?
        Rails.logger.info("Notifying API about new scan for domain: #{@domain.domain}")
        response = HTTParty.post(
          url,
          body: {
            enum_scan_id: enum_scan_id,
            vuln_scan_id: vuln_scan_id,
            scan_id: @domain.id,
            domain: @domain.domain,
            user_id: Current.session.user.id
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        unless response.success?
          Rails.logger.error("Failed to notify API about new scan: #{response.body}")
        end
      else
        Rails.logger.warn("API key is not configured, skipping API notification.")
      end
    end
end
