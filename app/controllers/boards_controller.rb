class BoardsController < ApplicationController
  def index
    @boards = Board.all.order(:name)
  end

  def show
    @board = Board.find_by(name: params[:name])

    raise ActiveRecord::RecordNotFound if @board.nil?

    @topics = @board.topics
                    .includes(posts_its_images_and_their_variants)
                    .order(updated_at: :desc).page(params[:page])

    # ? How to include a couple (not all) of preview posts with #include(:posts)?
  end

  private

  def posts_its_images_and_their_variants
    { posts: [:images_attachments, { images_blobs: { variant_records: { image_attachment: :blob } } }] }
  end
end
