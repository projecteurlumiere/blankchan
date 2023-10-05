module Authentication
  extend ActiveSupport::Concern

  included do
    def current_user
      @current_user ||= session[:user_id] ? user_by_session : user_by_token
    end

    def user_by_session
      User.find_by(id: session[:user_id])
    end

    def user_by_token
      user = User.find_by(id: cookies.encrypted[:user_id])
      return if user.nil? || !user&.remember_token_authenticated?(cookies.encrypted[:remember_token])

      sign_in user
      user
    end

    def user_signed_in?
      current_user.present?
    end

    def require_authentication
      return if user_signed_in?

      # flash[:warning]
      redirect_to root_path
    end

    def require_no_authentication
      return unless user_signed_in?

      # flash[:warning]
      redirect_to root_path
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def remember(user)
      user.remember
      cookies.encrypted.permanent[:user_id] = user.id
      cookies.encrypted.permanent[:remember_token] = user.remember_token
    end

    def sign_out
      current_user.remember_token_digest = nil
      session.delete :user_id
      cookies.delete :user_id
      cookies.delete :remember_token
      @current_user = nil
    end

    helper_method :current_user, :user_signed_in?
  end
end