class TopicsController < ApplicationController
  def show
    @topic = Topic.find(params[:id])

    @posts = @topic.posts.order(:created_at)
    @posts = PostsDecorator.decorate_collection(@posts.all)
  end

  def new
    @topic = Topic.new(board_id: board_by_name!.id)
  end

  def create
    @board = board_by_name!
    @topic = @board.topics.build

    if @topic.save && @topic.posts.build(topic_params[:post_attributes]).save
      redirect_to board_topic_path(@board.name, @topic.id)
    else
      @topic&.delete
      render :new, status: :unprocessable_entity
    end
  end

  private

  def board_by_name!
    board = Board.find_by(name: params[:board_name])
    raise ActiveRecord::RecordNotFound if board.nil?

    board
  end

  def topic_params
    params.require(:topic).permit(:board_id, post_attributes: %i[name text pic_link])
  end
end
