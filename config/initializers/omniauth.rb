Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    Rails.application.credentials.dig(:google, :client_id),
    Rails.application.credentials.dig(:google, :client_secret)

  if Rails.env.production?
    provider :github,
      Rails.application.credentials.dig(:github_prod, :client_id),
      Rails.application.credentials.dig(:github_prod, :client_secret)
  else
    provider :github,
      Rails.application.credentials.dig(:github_dev, :client_id),
      Rails.application.credentials.dig(:github_dev, :client_secret)
  end

  # Configure OmniAuth to use form_authenticity_token
  # Already handled by gem "omniauth-rails_csrf_protection"
  # OmniAuth.config.allowed_request_methods = [ :post ]

  # redirect to the failure endpoint on authentication failure
  # instead of rendering a cringe failure page in development
  OmniAuth.config.on_failure = Proc.new do |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  end
end
