class TopicPolicy < ApplicationPolicy
  attr_reader :user, :record

  def show?
    true
  end

  def create?
    true
  end

  def update
    false
  end

  def destroy?
    user.administrator_role? || user.moderator_role?
  end
end