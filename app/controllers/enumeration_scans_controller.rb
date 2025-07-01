class EnumerationScansController < ApplicationController
  before_action :set_domain
  before_action :set_scan, only: [ :show ]

  def show
    @results = @scan.enumeration_scan_results
  end

  private

  def set_domain
    @domain = Current.session.user.domains.find(params[:domain_id])
  end

  def set_scan
    @scan = @domain.enumeration_scans.find(params[:id])
  end
end
