class PostPolicy < ApplicationPolicy
  attr_reader :user, :record

  def create?
    true
  end


  def update?
    user.admin_role?
  end


  def destroy?
    user.admin_role? || (user.moderator_role? && user.moderator.supervised_board == record.topic.board.name)
  end
end