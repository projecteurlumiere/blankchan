module Admin
  class UsersController < ApplicationController
    before_action :require_authentication
    before_action :authorize_user!
    after_action :verify_authorized

    def index
      undesired_column_names = ["passcode_digest", "remember_token_digest" ]
      @user_columns = User.column_names.reject { |column| undesired_column_names.any?(column) }
      @users = User.all
    end

    def new; end

    def create
      @user = build_user
      if @user.save
        flash.notice = "User successfully created"
        flash.notice += " in case you didn't recieve (and this is dev env) an email here is your passcode: #{@user.passcode}" if Rails.env.development?
        PasscodeMailer.with(email: params[:user][:email], passcode: @user.passcode).issue_passcode_email.deliver_later
      else
        flash.now.alert = "Something went wrong"
      end

      redirect_to admin_users_path
    end

    def update
      @user = User.find(params[:id])

      case params[:directive]
      when "promote to moderator"
        promote_to_moderator
      when "dismiss moderator"
        dismiss_moderator
      end

      redirect_to admin_users_path(anchor: "user-id-#{@user.id}")
    end

    def destroy
      @user = User.find(params[:id])
      if !@user.admin_role? && @user.destroy
        flash[:success] = "User was successfully deleted."
        redirect_to admin_users_path
      else
        flash[:error] = "Something went wrong"
        redirect_to admin_users_path(anchor: "user-id-#{@user.id}"), status: :unprocessable_entity
      end
    end

    private

    def promote_to_moderator
      if @user.passcode_user_role? && @user.create_moderator
        flash.notice = "#{@user.id} has been promoted to moderator!"
      else
        flash.alert = "Couldn't promote #{@user.id} to moderator"
      end
    end

    def dismiss_moderator
      if @user.moderator_role? && @user.moderator.destroy
        flash.notice = "#{@user.id} moderator dismissed from duties, sir!"
      else
        flash.alert = "Couldn't dismiss moderator #{@user.id}"
      end
    end

    def build_user
      user = User.new(email: params[:email])

      until user.valid?
        passcode = SecureRandom.urlsafe_base64
        user.passcode = passcode
      end

      user
    end

    def authorize_user!
      authorize([:admin, @user || User])
    end
  end
end