class AiAnalysisService
  # Public interface for the service
  def self.call(page_data)
    new(page_data).call
  end

  # The main execution method for the service instance
  def call
    Rails.logger.info "AiAnalysisService called."
    prompt = build_prompt
    Rails.logger.debug "AI analysis prompt: #{prompt}"
    request_analysis(prompt)
  end

  private

  attr_reader :page_data, :client

  def initialize(page_data)
    @page_data = page_data
    # Initialize the RubyLLM client, configured to speak to our Azure deployment.
    # This is the only place in the application that needs to know these specifics.
    @client = RubyLLM.chat(
      model: Rails.application.credentials.dig(:azure_openai, :deployment_name),
      provider: :openai,
      assume_model_exists: true
    )
  end

  def build_prompt
    # Prompt engineering logic is encapsulated here.
    # This will be detailed in Part 3.1.
    # For now, a simple example:
    <<~PROMPT
    You are an expert cybersecurity specialist. Analyze the following data and provide a summary.
    Users are generally looking for insights into vulnerabilities, security issues, or potential improvements based on the provided data.
    Users are not looking for detailed technical explanations, but rather actionable insights or summaries that can guide their next steps.
    Users may not be familiar with technical jargon, so responses should be clear and concise.
    Use bullet points for clarity and focus on the most critical issues.
    Data:
    """
    #{page_data.to_json}
    """
    Respond with a JSON object containing a 'summary' key.
    PROMPT
  end

  def request_analysis(prompt)
    # The actual API call and its error handling are isolated here.
    Rails.logger.info "Requesting analysis from LLM."
    response = client.ask(prompt)
    Rails.logger.info "Received response from LLM."
    response
  end
end
