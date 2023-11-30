class ApplicationController < ActionController::Base
  include ErrorHandling
  include Authentication
  include Authorization

  def get_board_by_name!
    @board = Board.find_by(name: params[:board_name])
    raise ActiveRecord::RecordNotFound if @board.nil?
  end
end
