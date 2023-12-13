module Admin
  class BoardsController < ApplicationController
    def index
      undesired_column_names = []
      @board_columns = Board.column_names.reject { |column| undesired_column_names.any?(column) }

      @boards = Board.all.order(:id)
    end

    def new; end

    def create
      @new_board = Board.new(board_params)
      if @new_board.save
        flash.notice = "Board created"

        response.status = :found
        respond_to do |format|
          format.html { redirect_to board_path(@new_board.name) }
          format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, board_path(@new_board.name)) }
        end
      else
        flash.now.alert = "Board has not been created"
        response.status = :unprocessable_entity
        respond_to do |format|
          format.html { render :new }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("notifications", partial: "shared/notifications") }
        end
      end
    end

    def close
    end

    def destroy
      @board = Board.find_by(name: params[:name])

      if @board.destroy
        flash.notice = "Board deleted"
        redirect_to admin_boards_path
      else
        flash.now.alert = "Board could not be deleted"
        respond_to do |format|
          format.html { render :index }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("notifications", partial: "shared/notifications") }
        end
      end
    end

    private

    def board_params
      params.require(:board).permit(:name, :full_name)
    end
  end
end
