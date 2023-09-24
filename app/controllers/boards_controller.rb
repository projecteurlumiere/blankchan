class BoardsController < ApplicationController
  def index
    @boards = Board.all.order(:name)
  end

  def show
    @board = Board.find_by(name: params[:name])
    if @board
      @topics = Topic.where(board_id: @board.id).order(updated_at: :desc)
    else
      render_404
    end
  end
end
