class Topic < ApplicationRecord
  belongs_to :board
  has_many :posts

  accepts_nested_attributes_for :posts, :board

  validates :board_id, presence: true
end
