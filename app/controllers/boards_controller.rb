class BoardsController < ApplicationController
  before_action :authorize_board!

  after_action :verify_authorized

  def index
    @boards_name_and_full_name = Board.order(:name).pluck(:name, :full_name)
  end

  def show
    @board = Board.find_by(name: params[:name])
    raise ActiveRecord::RecordNotFound if @board.nil?

    @topics = @board.topics.order(updated_at: :desc).page(params[:page])

    # * somehow code below doesn't work, and partials keep prompting the db about image variants
    # * the best solution so far is asking for all attachments within the preview topic partial (see _preview_topic)
    # * it reduces n+1 but does not eliminate it completely :(
    # @topics = @board.topics
    #                 .includes(posts_its_images_and_their_variants)
    #                 .where(posts: {for_preview: true})
    #                 .order(updated_at: :desc).page(params[:page])

    # ? How to include a couple (not all) of preview posts with #include(:posts)?

    if params[:page].nil? || params[:page] == 1
      respond_to :html
    else
      respond_to :html, :turbo_stream
    end
  end

  private

  def posts_its_images_and_their_variants
    { posts: [:images_attachments, { images_blobs: { variant_records: { image_attachment: :blob } } }] }
  end

  def authorize_board!
    authorize(@board || Board)
  end
end
