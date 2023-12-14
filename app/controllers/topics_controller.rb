class TopicsController < ApplicationController
  before_action :get_board_by_name!, except: %i[destroy]

  before_action :require_authentication, only: %i[destroy]
  before_action :authorize_topic!, except: %i[destroy]

  after_action :verify_authorized

  def show
    @topic = Topic.find(params[:id])

    @posts = @topic.posts.includes(images_their_variants_and_replies).order(:id)

    # @posts = @topic.posts.with_attached_images
    # @posts = PostDecorator.decorate_collection(@posts.all)
  end

  def new
    @topic = Topic.new(board_id: @board.id)
  end

  def create
    @topic = @board.topics.build

    if create_topic!
      flash.notice = "Thread created"

      respond_to do |format|
        format.html { redirect_to board_topic_path(@board.name, @topic.id) }
        format.turbo_stream do
          render turbo_stream: turbo_stream.action(:redirect, board_topic_path(@board.name, @topic.id)), status: :found
        end
      end
    else
      flash.now.alert = "Thread was not created"
      @errors = @topic.errors.full_messages + @first_post.errors.full_messages

      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("notifications", partial: "shared/notifications"), status: :unprocessable_entity
        end
      end
    end
  end

  def show_admin
    @topic = Topic.find(params[:id])

    @post_ids = params[:post_ids].flatten

    respond_to do |format|
      format.turbo_stream { render :show_admin }
      format.html do
        flash.alert = "Admin panels for posts require javascript to work"
        redirect_to board_topic_path(@board.name, @topic)
      end
    end
  end

  def close
    @topic = Topic.find(params[:id])
    @topic.closed = true
    if @topic.save
      flash.notice = "Topic closed"
      respond_to do |format|
        format.html { redirect_to board_topic_path(@board.name, @topic) }
        format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, board_topic_path(@board.name, @topic)) }
      end
    else
      flash.now.alert = "Topic could not be closed"
      respond_to do |format|
        format.html { render :show }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notifications", partial: "shared/notifications") }
      end
    end
  end

  def open
    @topic = Topic.find(params[:id])
    @topic.closed = false
    if @topic.save
      flash.notice = "Topic opened"
      respond_to do |format|
        format.html { redirect_to board_topic_path(@board.name, @topic) }
        format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, board_topic_path(@board.name, @topic)) }
      end
    else
      flash.now.alert = "Topic could not be opened"
      respond_to do |format|
        format.html { render :show }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notifications", partial: "shared/notifications") }
      end
    end
  end

  def destroy
    if @topic = Topic.find_by(id: params[:id])
      authorize_topic!
      @topic.destroy

      flash.notice = "Topic deleted"
      redirect_to board_path(params[:board_name]), status: 303
    else
      flash.now.alert = "Topic not found"
      render board_path(params[:board_name]), status: :unprocessable_entity
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:board_id, post_attributes: [:name, :text, { images: [] }])
  end

  def create_topic!
    @topic.transaction do
      @topic.save!
      build_first_post.save! # ? why does it attach picture without explicit first_post.images.attach?
    end
  rescue ActiveRecord::RecordInvalid # should i add any other record?
    false
  end

  def build_first_post
    @first_post = @topic.posts.build(topic_params[:post_attributes]) # it does so because :post attributes contains ONLY necessary attributes (and nothing else)
    @first_post.author_ip = request.remote_ip
    @first_post.author_id = current_user&.id

    @first_post
  end

  def authorize_topic!
    authorize(@topic || Topic)
  end

  def images_their_variants_and_replies
    [:images_attachments, { images_blobs: { variant_records: { image_attachment: :blob } } }, replies: { posts: {topic: :board} }]

    # { posts: [:images_attachments, { images_blobs: { variant_records: { image_attachment: :blob } } }] }
  end
end
