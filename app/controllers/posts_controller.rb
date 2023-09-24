class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    @post.topic_id = params[:topic_id]
    if @post.save
      Topic.find_by(id: params[:topic_id]).touch
      redirect_to board_topic_path(params[:board_name], params[:topic_id], anchor: "post-id-#{@post.id}" )
    else
      render_partial :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:topic_id, :name, :text, :pic_link)
  end
end
