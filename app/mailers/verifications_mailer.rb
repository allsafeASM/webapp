class VerificationsMailer < ApplicationMailer
  def verify(user)
    @user = user
    @verification_url = verification_url(token: @user.generate_email_verification_token)
    mail(to: @user.email_address, subject: "Verify your email address")
  end
end
