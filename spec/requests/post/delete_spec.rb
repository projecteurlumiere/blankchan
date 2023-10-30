require "rails_helper"

RSpec.shared_examples "cannot delete posts" do
  it "does not allow deleting posts" do
    expect do
      delete board_topic_post_path(board.id, board.topics.first, board.topics.first.posts.first)
    end.not_to change(Post, :count)
  end
end


RSpec.describe "Post#destroy", type: :request do
  let!(:board) { create(:board) }
  let(:board_two) { create(:board) }

  before do
    unless RSpec.current_example.metadata[:no_login_required]
      login_as(current_user)
    end
  end

  context "when admin" do
    let(:current_user) { create(:administrator).user }

    it "allows deleting posts from any board" do
      expect do
        delete board_topic_post_path(board.id, board.topics.first, board.topics.first.posts.first)
      end.to change(Post, :count).by(-1)
    end

  end

  context "when moderator" do
    let(:current_user) { create(:moderator, supervised_board: board.name).user }

    it "allows deleting posts from the supervised board" do
      expect do
        delete board_topic_post_path(board.id, board.topics.first, board.topics.first.posts.first)
      end.to change(Post, :count).by(-1)
    end

    it "does not allow deleting posts from an unsupervised boards" do
      current_user.moderator.supervised_board = board_two.name
      current_user.moderator.save

      expect do
        delete board_topic_post_path(board.id, board.topics.first, board.topics.first.posts.first)
      end.not_to change(Post, :count)
    end
  end

  context "when passcode user" do
    let(:current_user) { create(:user) }

    include_examples "cannot delete posts"
  end

  context "when guest", :no_login_required do
    include_examples "cannot delete posts"
  end
end