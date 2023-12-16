module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized(exception)
      logger.warn(exception)
      msg = "You are not authorized to perform this action"
      respond_to do |format|
        format.turbo_stream do
          flash.now.alert = msg
          render turbo_stream: turbo_stream.replace("notifications", partial: "shared/notifications"), status: :forbidden
        end
        format.html do
          flash.alert = msg
          redirect_back fallback_location: root_path
        end
      end
    end
  end
end