require "rails_helper"

RSpec.describe BoardsController, type: :controller do
  describe "GET index" do
    before do
      get :index
    end

    it "prepares list of all boards" do
      all_boards = Board.all.order(:name)

      expect(assigns[:boards]).to eq(all_boards)
    end

    it "renders boards/index" do
      expect(response).to render_template(:index)
    end
  end
end
