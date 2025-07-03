class AiAnalysisJob < ApplicationJob
  queue_as :default

  # Configure robust retry logic for specific, transient network or API errors
  retry_on Faraday::ConnectionFailed, wait: :exponentially_longer, attempts: 5
  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(scan_data, analysis_target_id, scan_type, scan_id)
    Rails.logger.info "AiAnalysisJob started for scan_id: #{scan_id}, scan_type: #{scan_type}"
    Rails.logger.debug "AiAnalysisJob arguments: scan_data=#{scan_data.to_json}, analysis_target_id=#{analysis_target_id}"
    # Call the service object to perform the actual work
    response = AiAnalysisService.call(scan_data)
    Rails.logger.info "AiAnalysisService returned a response for scan_id: #{scan_id}"
    Rails.logger.debug "AI service response content: #{response.content}"

    # Parse the JSON response to get the summary
    parsed_response = JSON.parse(response.content)
    summary = parsed_response["summary"]

    # Broadcast the successful result to the UI via Turbo Streams
    Rails.logger.info "Broadcasting successful AI analysis result for scan_id: #{scan_id}"
    Turbo::StreamsChannel.broadcast_replace_to(
      "ai_analysis_#{scan_type}_#{scan_id}",
      target: analysis_target_id,
      partial: "shared/ai_analysis_result",
      locals: { result: summary }
    )
  rescue StandardError => e
    # Handle unexpected errors and broadcast an error state to the UI
    Rails.logger.error "AiAnalysisJob failed for scan_id: #{scan_id}. Error: #{e.message}\nBacktrace: #{e.backtrace.join("\n")}"
    Turbo::StreamsChannel.broadcast_update_to(
      "ai_analysis_#{scan_type}_#{scan_id}",
      target: analysis_target_id,
      partial: "shared/ai_analysis_error",
      locals: { message: "An error occurred during AI analysis. Please try again." }
    )
    Rails.logger.error "AiAnalysisJob failed: #{e.message}"
  end
end
