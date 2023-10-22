require 'rails_helper'

RSpec.describe "Boards", type: :request do
  describe "GET /index" do
    xit "returns http success" do
      get "/boards/index"
      expect(response).to have_http_status(:success)
    end
  end

end
