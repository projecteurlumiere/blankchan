require "rails_helper"

RSpec.shared_examples "cannot manage moderators" do
  it "does not allow promoting users to moderators" do
    expect do
      patch admin_user_path(user.id, params: { directive: "promote to moderator" })
    end.not_to change(Moderator, :count)

    expect(user.reload).to be_passcode_user_role
  end

  it "does not allow dismissing moderators to users" do
    expect do
      patch admin_user_path(moderator.id, params: { directive: "dismiss moderator" })
    end.not_to change(Moderator, :count)

    expect(moderator.reload).to be_moderator_role
  end
end

RSpec.describe "Admin/user#update", type: :request do
  let!(:admin) { create(:administrator).user }
  let!(:moderator) { create(:moderator).user }
  let(:user) { create(:user) }
  let!(:several_users) { create_list(:user, 5) }

  before do
    unless RSpec.current_example.metadata[:no_login_required]
      login_as(current_user)
    end

    user
  end

  context "when admin" do
    let(:current_user) { create(:administrator).user }

    it "allows promoting users to moderators" do
      expect do
        patch admin_user_path(user.id, params: { directive: "promote to moderator" })
      end.to change(Moderator, :count).by(1)
      expect(user.reload).to be_moderator_role
    end

    it "allows to dismiss moderators to users" do
      expect do
        patch admin_user_path(moderator.id, params: { directive: "dismiss moderator" })
      end.to change(Moderator, :count).by(-1)

      expect(moderator.reload).to be_passcode_user_role
    end
  end

  context "when moderator" do
    let(:current_user) { create(:moderator).user }

    include_examples "cannot manage moderators"
  end

  context "when passcode user" do
    let(:current_user) { create(:user) }

    include_examples "cannot manage moderators"
  end

  context "when guest", :no_login_required do
    include_examples "cannot manage moderators"
  end
end
