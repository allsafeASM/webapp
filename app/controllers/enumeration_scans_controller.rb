class EnumerationScansController < ApplicationController
  before_action :set_domain
  before_action :set_scan, only: [ :show ]

  def show
    @results = @scan.enumeration_scan_results

    respond_to do |format|
      format.html
      format.turbo_stream { render "show", locals: { scan: @scan, results: @results } }
    end
  end

  private

  def set_domain
    @domain = Current.session.user.domains.find(params[:domain_id])
  end

  def set_scan
    @scan = @domain.enumeration_scans.find(params[:id])
  end
end
