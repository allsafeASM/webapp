class AiAnalysesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_domain
  before_action :set_scan

  def create
    Rails.logger.info "AiAnalysesController#create called for scan: #{@scan.id} of type #{@scan.class.name}"
    # Extract the necessary data from the scan and its results
    scan_data = build_scan_data
    Rails.logger.debug "Scan data for AI analysis: #{scan_data.to_json}"

    # Generate a unique DOM ID for the Turbo Stream target
    analysis_target_id = "ai_analysis_result_#{@scan.class.name.underscore}_#{@scan.id}"
    Rails.logger.info "AI analysis target ID: #{analysis_target_id}"

    # Enqueue the background job to perform the analysis
    AiAnalysisJob.perform_later(
      scan_data,
      analysis_target_id,
      @scan.class.name.underscore,
      @scan.id
    )
    Rails.logger.info "AiAnalysisJob enqueued for scan: #{@scan.id}"

    # Respond immediately with a Turbo Stream to update the UI with a loading state
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            analysis_target_id,
            partial: "shared/ai_analysis_loading",
            locals: { message: "🤖 AI Analysis in progress... This may take a few moments." }
          ),
          turbo_stream.remove(dom_id(@scan, :ai_analysis_button_container))
        ]
      end
    end
  end

  private

  def set_domain
    @domain = Current.session.user.domains.find(params[:domain_id])
  end

  def set_scan
    if params[:vulnerability_scan_id]
      @scan = @domain.vulnerability_scans.find(params[:vulnerability_scan_id])
    elsif params[:enumeration_scan_id]
      @scan = @domain.enumeration_scans.find(params[:enumeration_scan_id])
    else
      redirect_to domain_path(@domain), alert: "Scan not found."
    end
  end

  def build_scan_data
    base_data = {
      scan_type: @scan.class.name.underscore,
      scan_id: @scan.id,
      domain: @domain.domain,
      status: @scan.status,
      created_at: @scan.created_at,
      completed_at: @scan.completed_at
    }

    case @scan
    when VulnerabilityScan
      base_data.merge({
        progress: @scan.progress,
        severity: @scan.severity,
        vulnerability_results: @scan.vulnerability_scan_results.map do |result|
          {
            name: result.name,
            host: result.host,
            severity: result.severity,
            vuln_type: result.vuln_type,
            template: result.template,
            cve_id: result.cve_id,
            cvss_score: result.cvss_score,
            description: result.description,
            reference: result.reference,
            matched_at: result.matched_at
          }
        end
      })
    when EnumerationScan
      base_data.merge({
        total_assets: @scan.total_assets,
        enumeration_results: @scan.enumeration_scan_results.map do |result|
          {
            name: result.name,
            url: result.url,
            ip: result.ip,
            port: result.port,
            status_code: result.status_code,
            title: result.title,
            webserver: result.webserver
          }
        end
      })
    end
  end
end
