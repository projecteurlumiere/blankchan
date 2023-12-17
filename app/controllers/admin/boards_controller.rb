module Admin
  class BoardsController < ApplicationController
    before_action :require_authentication
    before_action :authorize_board!

    after_action :verify_authorized

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

        respond_to do |format|
          format.html { redirect_to board_path(@new_board.name) }
          format.turbo_stream do
            render turbo_stream: turbo_stream.action(:redirect, board_path(@new_board.name)), status: :see_other
          end
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

    def update
      @board = Board.find_by(name: params[:name])
      if @board.update(board_update_params)
        flash.notice = "Board changes were made"

        respond_to do |format|
          format.html { redirect_to admin_boards_path_with_anchor }
          format.turbo_stream do
            render turbo_stream: turbo_stream.action(:redirect, admin_boards_path_with_anchor), status: :see_other
          end
        end
      else
        flash.alert = "Something went wrong"
        response.status = :unprocessable_entity

        respond_to do |format|
          format.html { render :index }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("notifications", partial: "shared/notifications") }
        end
      end
    end

    def destroy
      @board = Board.find_by(name: params[:name])

      if @board.destroy
        flash.notice = "Board deleted"
        redirect_to admin_boards_path
      else
        flash.now.alert = "Board could not be deleted"
        response.status = :unprocessable_entity

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

    def board_update_params
      params.require(:board).permit(:closed)
    end

    def authorize_board!
      authorize([:admin, @board || Board])
    end

    def admin_boards_path_with_anchor
      admin_boards_path(params: { anchor: "board-id-#{@board.id}" })
    end
  end
end
