class Moderator < ApplicationRecord
  belongs_to :user

  validates :supervised_board, inclusion: { in: Board.all.pluck(:name), message: "Must assign existing board to supervise" }, if: :supervised_board

  after_create :promote_user_role
  after_destroy :dismiss_user_role

  private

  def promote_user_role
    user.update_attribute("role", 1)
  end

  def dismiss_user_role
    user.update_attribute("role", 0)
  end
end



