module Admin
  class TopicsController < ApplicationController
    before_action :require_authentication
    before_action :authorize_topic!, except: %i[show]

    after_action :verify_authorized

    def show
      @topic = Topic.find(params[:id])
      authorize_topic!
      @board = @topic.board

      @post_ids = params[:post_ids].flatten

      respond_to do |format|
        format.turbo_stream
        format.html do
          flash.alert = "Admin panels for posts require javascript to work"
          redirect_to board_topic_path(@board.name, @topic)
        end
      end
    end

    private

    def authorize_topic!
      authorize([:admin, @topic || Topic])
    end
  end
end
