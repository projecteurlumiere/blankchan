class SessionsController < ApplicationController
  before_action :require_authentication, only: :destroy
  before_action :require_no_authentication, only: %i[new create]

  def new
  end

  def create
    if (user = find_user_by_passcode)
      sign_in user
      remember user
      flash.notice = "Successfully signed in"
      redirect_to root_url
    else
      flash.now.alert = "Could not sign in"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    flash.notice = "Successfully signed out"
    redirect_to root_url
  end

  private

  def find_user_by_passcode
    User.find_by(passcode_digest: User.digest(params[:passcode])) # maybe just rewrite it as model's class method?
  end
end
