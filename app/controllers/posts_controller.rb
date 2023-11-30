class PostsController < ApplicationController
  before_action :get_board_by_name!, only: %i[new create]

  before_action :require_authentication, only: %i[update destroy]
  before_action :authorize_post!, except: %i[destroy]

  after_action :verify_authorized

  def new
    @topic = Topic.find(params[:topic_id])
  end

  def create
    @topic = Topic.find(params[:topic_id])
    params[:topic_id] = nil # so that post.save can save images without .attach method

    @post = @topic.posts.build(post_params)
    record_ip

    if @post.save
      flash.notice = "Post created successfully"
      respond_to do |format|
        format.html { redirect_to post_with_anchor_path, status: :found }
        format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, post_with_anchor_path), status: :found }
      end
    else
      flash.now.alert = "Could not create post"
      @errors = @post.errors.full_messages

      @posts = @topic.posts.all
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("notifications", partial: "shared/notifications"), status: :unprocessable_entity
        end
      end

    end
  end

  def update
    @post = Post.find_by(id: params[:id])

    unless @post.blessed
      @post.text = @post.text + "\n\nThis post has been blessed"
      @post.blessed = true
      @post.save!
      flash.notice = "Post blessed"
    else
      flash.alert = "Post has already been blessed!"
    end

    redirect_back fallback_location: board_topic_path(params[:board_name], params[:topic_id])
  end

  def destroy
    if @post = Post.find_by(id: params[:id])
      authorize_post!
      @post.destroy
      @topic = Topic.find_by(id: params[:topic_id])
      flash.notice = "Post deleted"
      if @topic.posts.empty?
        @topic.destroy
        flash.notice = "Topic deleted"
      end
    else
      flash.alert = "Post not found"
    end

    redirect_back fallback_location: board_topic_path(params[:board_name], params[:topic_id])
  end

  private

  def post_params
    params.require(:post).permit(:topic_id, :name, :text, images: [])
  end

  def record_ip
    @post.author_ip = request.remote_ip
    @post.author_id = current_user&.id
  end

  def post_with_anchor_path
    board_topic_path(@board.name, @topic.id, anchor: "post-id-#{@post.id}")
  end

  def authorize_post!
    authorize(@post || Post)
  end
end
