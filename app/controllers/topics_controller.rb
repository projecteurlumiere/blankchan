class TopicsController < ApplicationController
  before_action :require_authentication, only: %i[destroy]
  before_action :authorize_topic!
  after_action :verify_authorized

  def show
    @board = board_by_name!
    @topic = Topic.find(params[:id])

    # @posts = @topic.posts.with_attached_images
    # @posts = PostDecorator.decorate_collection(@posts.all)
  end

  def new
    @topic = Topic.new(board_id: board_by_name!.id)
  end

  def create
    @board = board_by_name!
    @topic = @board.topics.build

    if @topic.save && build_first_post.save # ? why does it attach picture without explicit first_post.images.attach?
      flash.notice = "Thread created"
      redirect_to board_topic_path(@board.name, @topic.id)
    else
      @topic&.delete
      @errors = @topic.errors.full_messages + @first_post.errors.full_messages
      flash.now.alert = "Thread was not created"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @topic = Topic.find_by(id: params[:id])
      @topic.delete
      flash.notice = "Topic deleted"
      redirect_to board_path(params[:board_name])
    else
      flash.now.alert = "Topic not found"
      render board_path(params[:board_name]), status: :unprocessable_entity
    end
  end

  private

  def board_by_name!
    board = Board.find_by(name: params[:board_name])
    raise ActiveRecord::RecordNotFound if board.nil?

    board
  end

  def topic_params
    params.require(:topic).permit(:board_id, post_attributes: [:name, :text, images: []])
  end

  def build_first_post
    @first_post = @topic.posts.build(topic_params[:post_attributes])
  end

  def authorize_topic!
    authorize(@topic || Topic)
  end

  def posts_its_images_and_their_variants
    { posts: [:images_attachments, { images_blobs: { variant_records: { image_attachment: :blob } } }] }
  end
end
