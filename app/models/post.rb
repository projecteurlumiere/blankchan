class Post < ApplicationRecord
  MAX_POSTS = 220

  # Post may address as many posts as it wants, and we use reply_id to represent it
  has_many :addressing_posts, foreign_key: :reply_id, class_name: "Reply"
  has_many :posts, through: :addressing_posts

  # Post may be addressed to by as many posts (it may or may not want), and we use post_id to represent it
  has_many :replying_posts, foreign_key: :post_id, class_name: "Reply"
  has_many :replies, through: :replying_posts

  belongs_to :topic

  has_many_attached :images

  before_create :parse_for_replying

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

  def parse_for_replying
    reply_regexp = />>\d+/
    reply_ids = text.scan(reply_regexp).map { |match| match.delete_prefix(">>") }

    reply_posts = Post.includes(topic: :board).where(id: reply_ids)

    reply_posts.each do |match|
      next unless match

      if match.topic.board == self.topic.board
        self.posts << match
        self.text = text.sub(">>#{match.id}", "<a href='#{Rails.application.routes.url_helpers.board_topic_path(match.topic.board.name, match.topic_id)}#post-id-#{match.id}'>>>#{match.id}</a>")
      end
    end
  end
end
