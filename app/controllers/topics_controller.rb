class TopicsController < ApplicationController
  def show
    @topic = Topic.find_by_id(params[:id])

    render_404 and return unless @topic

    @posts = Post.where(topic_id: @topic).order(:created_at)

    @post = Post.new
  end

  def new
    @topic = Topic.new(board_id: board_by_name&.id)
  end

  def create
    @board = board_by_name
    @topic = Topic.new(board_id: @board.id)
    @first_post = Post.new(topic_params[:post_attributes])

    if @topic.save && save_first_post
      redirect_to board_topic_path(@board.name, @topic.id)
    else
      @topic&.delete
      render :new, status: :unprocessable_entity
    end
  end

  private

  def board_by_name
    board = Board.find_by(name: params[:board_name])
    render_404 and return unless board
  end

  def save_first_post
    @first_post.topic_id = @topic.id
    @first_post.save
  end

  def topic_params
    params.require(:topic).permit(:board_id, post_attributes: [ :name, :text, :pic_link ])
  end
end
