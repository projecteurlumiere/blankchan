require "rails_helper"

RSpec.describe "boards controller", type: :system do
  let!(:board) { create(:board) }

  it "renders names of boards at root path" do
    visit root_path

    expect(page).to have_content("/#{board.name}/", count: 2)
  end
end
