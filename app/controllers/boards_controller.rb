class BoardsController < ApplicationController
  def index
    @boards = Board.all
  end

  def show
    @board = Board.find_by(name: params[:id])
    if @board
      @topics = Topic.where(board_id: @board.id)
      render "show"
    else
      render_404
    end
  end
end
