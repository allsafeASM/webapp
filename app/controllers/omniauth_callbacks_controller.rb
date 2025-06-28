class OmniauthCallbacksController < ApplicationController
  allow_unauthenticated_access

  def callback
    provider = auth_hash.provider.to_s
    provider_name = provider == "google_oauth2" ? "Google" : provider.capitalize

    if authenticated?
      user = Current.session.user
      Identity.find_or_create_from_auth_hash(user, auth_hash)
      redirect_to account_path, notice: "Successfully linked your #{provider_name} account."
    else
      user = User.from_omniauth(auth_hash)

      if user.present?
        start_new_session_for(user)
        redirect_to after_authentication_url, notice: "Successfully signed in with #{provider_name}."
      else
        redirect_to new_session_path, alert: "We couldn't sign you in. Please try again."
      end
    end
  end

  def failure
    strategy_name = params[:strategy].to_s.humanize if params[:strategy].present? && params[:strategy] != "unknown"
    provider_name = strategy_name || "the authentication provider" # More generic default

    alert_message = "Authentication with #{provider_name} failed. Please try again." # Default

    case params[:message] # This comes from the 'message' query param set by OmniAuth's failure handler
    when "access_denied"
      alert_message = "You denied the access request from #{provider_name}."
    when "invalid_credentials"
      alert_message = "Invalid credentials for #{provider_name}."
    when "timeout"
      alert_message = "The connection to #{provider_name} timed out."
    when "failed_to_connect"
      alert_message = "Failed to connect to #{provider_name}."
    # Add more specific OmniAuth error messages as needed by inspecting params[:message]
    else
      if params[:message].present? && params[:message] != "unknown_error" && params[:message] != "csrf_detected"
        # A generic message for other specific errors if they are not too technical
        alert_message = "Authentication with #{provider_name} failed: #{params[:message].humanize}."
      elsif params[:message] == "csrf_detected"
        alert_message = "Authentication with #{provider_name} failed due to a security issue. Please try again."
      end
    end
    redirect_to root_url, alert: alert_message
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
