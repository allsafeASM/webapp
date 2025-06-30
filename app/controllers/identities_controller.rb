class IdentitiesController < ApplicationController
  before_action :set_identity

  def destroy
    @identity.destroy
    redirect_to account_path, notice: "The account has been unlinked."
  end

  private

  def set_identity
    @identity = Current.session.user.identities.find(params[:id])
  end
end
