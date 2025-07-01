require "httparty"

class DomainsController < ApplicationController
  before_action :set_domain, only: [ :show, :destroy ]

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
        format.turbo_stream { render :create_failure, status: :unprocessable_entity }
        format.html { render :index, status: :unprocessable_entity }
      end
    end
    api_key = Rails.application.credentials.dig(:api_key)
    url = "https://asm-durable-function.azurewebsites.net/api/orchestrators/start_scan?code=#{api_key}"
    if api_key.present?
      # Notify the external API about the new scan request
      Rails.logger.info("Notifying API about new domain: #{@domain.domain}, ID: #{@domain.id}")
      response = HTTParty.post(
        url,
        body: { scan_id: @domain.id, domain: @domain.domain }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      unless response.success?
        Rails.logger.error("Failed to notify API about new domain: #{response.body}")
      end
    else
      Rails.logger.warn("API key is not configured, skipping API notification for new domain.")
    end
  end

  def destroy
    @domain.destroy
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
end
