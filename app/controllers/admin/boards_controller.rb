module Admin
  class BoardsController < ApplicationController
    def index
      undesired_column_names = []
      @board_columns = Board.column_names.reject { |column| undesired_column_names.any?(column) }

      @boards = Board.all.order(:id)
    end

    def new; end

    def create
      Board.new(params[:name])
      if Board.save
        flash.notice = "Board created"
        redirect_to Board
      end
    end

    def close
    end

    def destroy
    end
  end
end
