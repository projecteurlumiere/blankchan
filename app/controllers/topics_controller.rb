class TopicsController < ApplicationController
  # def index
  # end

  def show
    @topic = Topic.find_by_id(params[:id])

    render_404 unless @topic

    @posts = Post.where(topic_id: @topic)
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
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
