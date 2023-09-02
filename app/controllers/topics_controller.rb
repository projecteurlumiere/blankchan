class TopicsController < ApplicationController
  # def index
  # end

  def show
    @topic = Topic.find_by_id(params[:id])

    render_404 unless @topic

    @posts = Post.where(topic_id: @topic)
  end

  def new 
    @topic = Topic.new(board_id: Board.find_by(name: params[:board_id]).id)
  end

  def create
    @board = Board.find_by(name: params[:board_id])
    @topic = Topic.new(board_id: @board.id)
    @first_post = Post.new(name: params[:topic][:post][:name], text: params[:topic][:post][:text], pic_link: params[:topic][:post][:pic_link])
    if @topic.valid?
      @topic.save
      @first_post.topic_id = @topic.id
      if @first_post.valid?
        @first_post.save
        redirect_to board_topic_path(@board.name, @topic.id)
      else
        @topic.delete
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:board_id, :name, :text, :pic_link)
  end
end
