class Post < ApplicationRecord
  belongs_to :topic, touch: true
  has_many_attached :images
  after_save :set_preview_posts

  validates :topic_id, presence: true
  validates :name, length: { maximum: 100 }
  validates :text, length: { minimum: 5, maximum: 2000 }
  # validates :text, presence: true

  def image_as_thumb(image)
    image.variant(resize_to_limit: [200, 200]).processed
  end

  private

  def set_preview_posts
    first_post = topic.posts.first
    if self == first_post
      self.update_columns(for_preview: true)
      return
    end

    last_posts = topic.posts.last(4)

    if last_posts.last(3).include?(self)
      update_columns(for_preview: true)
    end

    return if last_posts.include?(first_post)

    last_posts.first.update_columns(for_preview: false)
  end
end
