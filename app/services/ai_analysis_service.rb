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
    @client = OpenAI::Client.new
  end

  def build_prompt
    # Prompt engineering logic is encapsulated here.
    # This will be detailed in Part 3.1.
    # For now, a simple example:
    <<~PROMPT
    You are an expert cybersecurity specialist. Analyze the following data and provide a summary.
    Users are generally looking for insights into vulnerabilities, security issues, or potential improvements based on the provided data.
    Responses should be clear and concise.
    Data:
    """
    #{page_data.to_json}
    """
    Respond with a JSON object containing
    - a 'summary' key, this contains a short summary of the types of vulnerabilities or security issues identified in the data.
    - an 'immediate_actions' key, this contains a list of immediate actions that can be taken to address the identified impactful vulnerabilities.
    - a 'recommendations' key, this contains actionable recommendations for improving security based on the analysis, this will be a list.
    PROMPT
  end

  def request_analysis(prompt)
    # The actual API call and its error handling are isolated here.
    Rails.logger.info "Requesting analysis from LLM."
    response = client.chat(
      parameters: {
        model: Rails.application.credentials.dig(:azure_openai, :deployment_name),
        messages: [ { role: "user", content: prompt } ],
        max_tokens: 1000,
        temperature: 0.7
      }
    )
    Rails.logger.info "Received response from LLM."
    response.dig("choices", 0, "message", "content")
  rescue => e
    Rails.logger.error "Error requesting analysis: #{e.message}"
    raise
  end
end
