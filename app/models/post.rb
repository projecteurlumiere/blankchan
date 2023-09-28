class Post < ApplicationRecord
  belongs_to :topic, touch: true

  validates :topic_id, presence: true
  validates :name, length: { maximum: 100 }
  validates :text, length: { minimum: 5, maximum: 2000 }
  # validates :text, presence: true
end
