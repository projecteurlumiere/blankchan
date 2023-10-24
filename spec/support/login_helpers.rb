# spec/support/controller_macros.rb
module LoginHelpers
  def login_as(user)
    post "/session", params: { passcode: user.passcode }
  end
end
