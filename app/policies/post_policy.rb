class PostPolicy < ApplicationPolicy
  attr_reader :user, :record

  def show?
    false
  end

  def create?
    true
  end


  def update?
    user.administrator_role?
  end


  def destroy?
    user.moderator_role? || user.administrator_role?
  end
end