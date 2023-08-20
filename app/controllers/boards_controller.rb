class BoardsController < ApplicationController
  def index
    @boards = Board.all
  end

  def show
    @board = Board.find_by(name: params[:id])
    if @board
      @threads = Thread.all
      render "show"
    else
      render_404
    end
  end
end
