# since routing errors happen before controller kicks in, it's not possible to handle the error here
# unless all routing errors are routed to the controller explicitly

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    private

    def render_not_found(exception)
      logger.warn(exception)
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end
end