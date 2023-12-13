class Board < ApplicationRecord
  has_many :topics, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :full_name, presence: true, uniqueness: true

  def self.all_names
    Rails.cache.fetch("test/boards", expires_in: 12.hours) do
      Board.all.order(:name).each_with_object([]) do |board, array|
        array << board.name
      end
    end
  end
end
