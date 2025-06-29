class IdentitiesController < ApplicationController
  before_action :set_identity

  def destroy
    user = Current.session.user
    if user.identities.count == 1 && user.password_digest.nil?
      redirect_to account_path, alert: "You cannot unlink your only sign-in method. Please set a password first."
      return
    end

    @identity.destroy
    redirect_to account_path, notice: "The account has been unlinked."
  end

  private

  def set_identity
    @identity = Current.session.user.identities.find(params[:id])
  end
end
