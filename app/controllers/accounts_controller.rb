class AccountsController < ApplicationController
  def show
    @user = Current.session.user
    @identities = @user.identities
  end
end
