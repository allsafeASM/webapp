class DomainsController < ApplicationController
  before_action :set_domain, only: [:show, :destroy]

  def index
    @domains = Current.session.user.domains.order(created_at: :desc)
    @domain = Domain.new
  end

  def show
    # @domain is set by before_action
  end

  def create
    @domain = Current.session.user.domains.build(domain_params)
    if @domain.save
      redirect_to domains_path, notice: 'Domain scan requested.'
    else
      @domains = Current.session.user.domains.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @domain.destroy
    redirect_to domains_path, notice: 'Domain scan deleted.'
  end

  private
    def set_domain
      @domain = Current.session.user.domains.find(params[:id])
    end

    def domain_params
      params.require(:domain).permit(:domain)
    end
end
