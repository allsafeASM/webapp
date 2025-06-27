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
  end

  def destroy
    @domain.destroy
  end

  private
    def set_domain
      @domain = Current.session.user.domains.find(params[:id])
    end

    def domain_params
      params.require(:domain).permit(:domain)
    end
end
