class TopicPolicy < ApplicationPolicy
  attr_reader :user, :record

  def show?
    true
  end

  def create?
    true
  end

  def update?
    admin_or_supervisor?
  end

  def destroy?
    admin_or_supervisor?
  end

  private

  def admin_or_supervisor?
    user.admin_role? || (user.moderator_role? && user.moderator.supervised_board == record.board.name)
  end
end