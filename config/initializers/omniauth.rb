Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET']
  
  # Configure OmniAuth to use form_authenticity_token
  OmniAuth.config.allowed_request_methods = [:post]

  # redirect to the failure endpoint on authentication failure
  # instead of rendering a cringe failure page in development
  OmniAuth.config.on_failure = Proc.new do |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  end
end
