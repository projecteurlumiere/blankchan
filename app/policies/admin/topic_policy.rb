module Admin
  class TopicPolicy < ApplicationPolicy
    attr_reader :user, :record

    def show?
      admin_or_supervisor?
    end

    private

    def admin_or_supervisor?
      user.admin_role? || (user.moderator_role? && user.moderator.supervised_board == record.board.name)
    end
  end
end