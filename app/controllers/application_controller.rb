class ApplicationController < ActionController::Base
  include ErrorHandling
  include Authentication
  include Pundit::Authorization
end
