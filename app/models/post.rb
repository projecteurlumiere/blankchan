class Post < ApplicationRecord
  MAX_POSTS = 220

  # Post may address as many posts as it wants, and we use reply_id to represent it
  #? is dependent destroy a good idea?
  has_many :addressing_posts, foreign_key: :reply_id, class_name: "Reply", dependent: :destroy
  has_many :posts, through: :addressing_posts

  # Post may be addressed to by as many posts (it may or may not want), and we use post_id to represent it
  #? is dependent destroy a good idea?
  has_many :replying_posts, foreign_key: :post_id, class_name: "Reply", dependent: :destroy
  has_many :replies, through: :replying_posts

  belongs_to :topic
  delegate :board, to: :topic, allow_nil: false

  has_many_attached :images

  before_create :parse_for_replying

  after_save :set_preview_posts
  after_save :touch_topic

  after_destroy proc { topic.destroy }, if: proc { topic.posts.none? }
  after_destroy :touch_siblings, if: proc { topic.posts.any? }

  validates :topic_id, presence: true
  validates :name, length: { maximum: 100 }
  validates :text, length: { minimum: 5, maximum: 2000 }
  validates :board, presence: true

  validate :board_open
  validate :topic_open

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

  #? Still, is it a good idea to put formatted <a> tag in the db and not format it on the fly in the view?

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

  def board_open
    errors.add(:board, "must not be closed") if board.closed?
  end

  def topic_open
    errors.add(:topic, "must not be closed") if topic.closed?
  end

  def touch_siblings
    topic.posts.touch_all
  end
end
