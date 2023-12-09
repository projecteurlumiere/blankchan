require "rails_helper"

RSpec.describe BoardsController, type: :controller do
  describe "GET index" do
    before do
      get :index
    end

    it "prepares list of all boards" do
      all_boards = Board.order(:name).pluck(:name, :full_name)

      expect(assigns[:boards_name_and_full_name]).to eq(all_boards)
    end

    it "renders boards/index" do
      expect(response).to render_template(:index)
    end
  end
end
