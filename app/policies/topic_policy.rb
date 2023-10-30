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
    user.admin_role? || (user.moderator_role? && user.moderator.supervised_board == record.board.name)
  end
end