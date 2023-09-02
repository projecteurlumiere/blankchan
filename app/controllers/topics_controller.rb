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
    @topic = Topic.new(board_id: Board.find_by(name: params[:board_id]).id)
    @first_post = Post.new(name: params[:name], text: params[:text], pic_link: params[:pic_link])
    if @topic.valid? && @first_post.valid?
      @topic.save
      @first_post.topic_id = @topic.id
      @first_post.save
      redirect_to @topic
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:board_id, :name, :text, :pic_link)
  end
end
