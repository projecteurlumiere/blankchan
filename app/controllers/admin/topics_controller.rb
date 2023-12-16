module Admin
  class TopicsController < ApplicationController
    def show
      @topic = Topic.find(params[:id])
      @board = @topic.board

      @post_ids = params[:post_ids].flatten

      respond_to do |format|
        format.turbo_stream { render :show }
        format.html do
          flash.alert = "Admin panels for posts require javascript to work"
          redirect_to board_topic_path(@board.name, @topic)
        end
      end
    end
  end
end
