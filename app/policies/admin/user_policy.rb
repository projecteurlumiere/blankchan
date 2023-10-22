module Admin
  class UserPolicy < ApplicationPolicy
    attr_reader :user, :record

    def index?
      user.admin_role?
    end

    def create?
      user.admin_role?
    end


    def update?
      user.admin_role?
    end


    def destroy?
      user.admin_role?
    end
  end
end