class Topic < ApplicationRecord
  belongs_to :board
  has_many :posts

  validates :board_id, presence: true
end
