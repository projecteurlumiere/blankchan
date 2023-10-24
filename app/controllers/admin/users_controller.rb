module Admin
  class UsersController < ApplicationController
    before_action :require_authentication
    before_action :authorize_user!
    after_action :verify_authorized

    def index
      @users = User.all
    end

    def create
      @user = User.new(params[:object])
      if @user.save
        flash.notice = "Object successfully created"
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

    def authorize_user!
      authorize([:admin, @user || User])
    end
  end
end