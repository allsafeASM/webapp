# config/initializers/ruby_llm.rb
require "ruby_llm"

RubyLLM.configure do |config|
  # 1. Point to the Azure endpoint URL. This is the crucial setting for Azure integration.
  #    It's recommended to use environment variables for flexibility and security.
  config.openai_api_base = Rails.application.credentials.dig(:azure_openai, :endpoint)

  # 2. Provide the API key for your Azure resource.
  config.openai_api_key = Rails.application.credentials.dig(:azure_openai, :api_key)

  # 3. Configure resilience settings for production-grade reliability.
  #    Set a generous timeout for potentially long-running LLM requests.
  config.request_timeout = 180 # seconds

  #    Configure automatic retries with exponential backoff for transient errors.
  config.max_retries = 3
  config.retry_interval = 0.2 # Start with a 200ms delay
  config.retry_backoff_factor = 2 # Double the delay for each subsequent retry (0.2s, 0.4s, 0.8s)
end
