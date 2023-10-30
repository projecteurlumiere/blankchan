class PasscodeMailer < ApplicationMailer
  def issue_passcode_email
    email = params[:email]
    @passcode = params[:passcode]

    mail to: email, subject: "Your passcode is here!"
  end
end
