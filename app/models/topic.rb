class Topic < ApplicationRecord
  MAX_TOPICS = 30
  paginates_per 10

  belongs_to :board
  has_many :posts, dependent: :destroy

  accepts_nested_attributes_for :posts, :board

  validates :board_id, presence: true

  after_create :delete_the_oldest_topic

  private

  def delete_the_oldest_topic
    if board.topics.all.count > MAX_TOPICS
      last_topic = board.topics.includes({ posts: [:images_attachments, { images_blobs: { variant_records: { image_attachment: :blob } } }] }).order(updated_at: :desc).last
      last_topic.posts.destroy_all
      last_topic.destroy
    end
  end
end
