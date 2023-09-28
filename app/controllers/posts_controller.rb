class PostsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    if @post.save
      redirect_to board_topic_path(params[:board_name],
                                   @topic.id,
                                   anchor: "post-id-#{@post.id}" # ? anchors still do not work...
                                  )
    else
      # ? how about anchors here? or should client-side work with it

      @posts = @topic.posts.all
      render "topics/show", status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:topic_id, :name, :text, :pic_link)
  end
end
