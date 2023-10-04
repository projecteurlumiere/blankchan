class BoardsController < ApplicationController
  def index
    @boards = Board.all.order(:name)
  end

  def show
    @board = Board.find_by(name: params[:name])
    raise ActiveRecord::RecordNotFound if @board.nil?

    @topics = @board.topics.order(updated_at: :desc)
    TopicDecorator.decorate_collection(@topics.all)
  end
end
