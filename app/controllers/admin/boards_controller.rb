module Admin
  class BoardsController < ApplicationController
    before_action :require_authentication
    before_action :authorize_board!
    before_action :define_column_names, only: %i[index create update]

    after_action :verify_authorized

    def index
      @boards = Board.all.order(:id)
    end

    def new; end

    def create
      @board = Board.new(board_params)
      if @board.save
        flash.notice = "Board created"

        respond_to do |format|
          format.html do
            redirect_to board_path(admin_boards_path_with_anchor)
          end
          format.turbo_stream do
            render turbo_stream: turbo_stream.action(:redirect, admin_boards_path_with_anchor), status: :see_other
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

        respond_to do |format|
          format.html do
            flash.notice = "Board changes were made"
            redirect_to admin_boards_path_with_anchor
          end
          format.turbo_stream do
            flash.now.notice = "Board changes were made"
            @board.reload
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
        respond_to do |format|
          format.html do
            flash.notice = "Board deleted"
            redirect_to admin_boards_path
          end
          format.turbo_stream do
            flash.now.notice = "Board deleted"
          end
        end
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
      admin_boards_path(anchor: "board-id-#{@board.id}")
    end

    def define_column_names
      undesired_column_names = []
      @board_columns = Board.column_names.reject { |column| undesired_column_names.any?(column) }
    end
  end
end
