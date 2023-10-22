class PostPolicy < ApplicationPolicy
  attr_reader :user, :record

  def show?
    false
  end

  def create?
    true
  end


  def update?
    user.admin_role?
  end


  def destroy?
    user.moderator_role? || user.admin_role?
  end
end