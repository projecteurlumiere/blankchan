class Post < ApplicationRecord
  belongs_to :topic

  validates :topic_id, presence: true
  # validates :name, length: { maximum: 100 }
  # validates :text, length: { maximum: 2000 }
  # validates :text, presence: true
end
