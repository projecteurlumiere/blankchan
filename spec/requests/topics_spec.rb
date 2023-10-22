require 'rails_helper'

RSpec.describe "Topics", type: :request do
  describe "GET /index" do
    xit "returns http success" do
      get "/topics/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    xit "returns http success" do
      get "/topics/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    xit "returns http success" do
      get "/topics/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    xit "returns http success" do
      get "/topics/create"
      expect(response).to have_http_status(:success)
    end
  end

end
