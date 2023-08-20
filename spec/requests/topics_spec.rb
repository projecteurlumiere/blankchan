require 'rails_helper'

RSpec.describe "Topics", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/topics/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/topics/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/topics/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/topics/create"
      expect(response).to have_http_status(:success)
    end
  end

end
