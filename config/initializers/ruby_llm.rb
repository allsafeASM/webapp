# config/initializers/ruby_llm.rb
RubyLLM.configure do |config|
  # Point to the local Ollama server's OpenAI-compatible endpoint.
  # The '/v1' path is crucial for this compatibility mode. It instructs RubyLLM
  # to use the standard OpenAI protocol for communication.
  config.openai_api_base = ENV.fetch("OLLAMA_API_BASE", "http://localhost:11434/v1")

  # For a standard Ollama setup, an API key is not required. However, the gem's
  # configuration may expect a value to be present. Providing a non-empty string
  # like 'ollama' satisfies this requirement without compromising security.
  config.openai_api_key = ENV.fetch("OLLAMA_API_KEY", "ollama")

  # Set a generous request timeout to accommodate potentially slow model
  # generation on local hardware, preventing premature request termination.
  config.request_timeout = 180 # seconds
end
