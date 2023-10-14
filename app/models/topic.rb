class Topic < ApplicationRecord
  belongs_to :board
  paginates_per 15
  has_many :posts, dependent: :destroy

  accepts_nested_attributes_for :posts, :board

  validates :board_id, presence: true
end
