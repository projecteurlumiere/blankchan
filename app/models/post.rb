class Post < ApplicationRecord
  belongs_to :topic, touch: true
  has_many_attached :images

  validates :topic_id, presence: true
  validates :name, length: { maximum: 100 }
  validates :text, length: { minimum: 5, maximum: 2000 }
  # validates :text, presence: true

  def image_as_thumb(image)
    image.variant(resize_to_limit: [200, 200]).processed
  end
end
