class SessionsController < ApplicationController
  def new
  end

  def create
    user = find_user_by_passcode
    if user
      user.remember
      cookies[:remember_token] = user.remember_token
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def digest(code)
    Digest::SHA256.hexdigest(code)
  end

  def find_user_by_passcode
    User.find_by(passcode_digest: digest(params[:passcode]))
  end
end
