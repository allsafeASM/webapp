class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    unless user&.authenticate(params[:password])
      redirect_to new_session_path, alert: "Try another email address or password." and return
    end
    unless user.verified?
      VerificationsMailer.verify(user).deliver_later
      redirect_to new_session_path, alert: "You must verify your email before logging in. A verification email has been sent to you." and return
    end
    start_new_session_for user
    redirect_to after_authentication_url
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
