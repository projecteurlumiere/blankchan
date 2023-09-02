class PostsController < ApplicationController
  def create
    @post = Post.new(topic_id: params[:topic_id], name: params[:post][:name], text: params[:post][:text], pic_link: params[:post][:pic_link])
    if @post.save
      redirect_to board_topic_path(params[:board_id], params[:topic_id])
    end
  end
end
