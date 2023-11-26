class PostsController < ApplicationController
  before_action :require_authentication, only: %i[update destroy]
  before_action :authorize_post!, except: %i[destroy]
  after_action :verify_authorized

  def new
    @board = Board.find_by(name: params[:board_name])
    @topic = Topic.find(params[:topic_id])
  end

  def create
    @board = Board.find_by(name: params[:board_name])
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    @post.author_ip = request.remote_ip
    @post.author_id = current_user&.id
    if @post.save && @post.images.attach(params[:images])
      flash.notice = "Post created successfully"
      redirect_to board_topic_path(@board.name,
                                   @topic.id,
                                   anchor: "post-id-#{@post.id}" # ? anchors still do not work...
                                  )
    else
      # ? how about anchors here? or should client-side work with it?
      @post&.destroy

      flash.now.alert = "Could not create post"
      @errors = @post.errors.full_messages

      @posts = @topic.posts.all
      render "topics/show", status: :unprocessable_entity
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

  def authorize_post!
    authorize(@post || Post)
  end
end
