class PasscodesController < ApplicationController

  def new
  end

  def create
    if params[:i_paid] != "true"
      flash.now.alert = "Payment processing failure"
      render :new, status: :unprocessable_entity
      return
    end

    user = User.new(email: params[:email])

    until user.valid?
      passcode = SecureRandom.urlsafe_base64
      user.passcode = passcode
    end

    user.save

    PasscodeMailer.with(email: params[:email], passcode: passcode).issue_passcode_email.deliver_later

    flash.notice = "Success!"
    flash.notice += " in case you didn't recieve (and this is dev env) an email here is your passcode: #{passcode}" if Rails.env.development?
    redirect_to root_path
  end
end
