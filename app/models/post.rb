class Post < ApplicationRecord
  MAX_POSTS = 220

  belongs_to :topic
  has_many_attached :images

  # before_create :format_text_links

  after_save :set_preview_posts
  after_save :touch_topic

  validates :topic_id, presence: true
  validates :name, length: { maximum: 100 }
  validates :text, length: { minimum: 5, maximum: 2000 }
  # validates :text, presence: true

  def image_as_thumb(image)
    image.variant(resize_to_limit: [200, 200]).processed
  end

  private

  def touch_topic
    if topic.posts.count > MAX_POSTS
      topic.touch(time: topic.updated_at + 0.1.seconds)
    else
      topic.touch
    end
  end

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


  def format_text_links
    # links = URI.extract(text)
    # links.each do |link|
    #   text.sub!(link, "<a href='#{link}'>#{link}</a>") # and what about if it's already in <a> ?
    # end
    binding.pry

    self.text = auto_link(self.text, sanitize: false)
  end
end
