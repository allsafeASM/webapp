class VerificationsController < ApplicationController
  allow_unauthenticated_access only: :show
  
  def show
    user = User.find_by_email_verification_token!(params[:token])
    user.update!(verified_at: Time.current)
    redirect_to new_session_path, notice: "Your email has been verified. You can now log in."
  rescue ActiveRecord::RecordNotFound
    redirect_to new_session_path, alert: "Invalid or expired verification link."
  end
end
