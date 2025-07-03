require "openai"

OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.dig(:azure_openai, :api_key)
  config.uri_base = Rails.application.credentials.dig(:azure_openai, :endpoint)
  config.api_type = :azure
  config.api_version = "2024-02-01"
  config.request_timeout = 180
end
