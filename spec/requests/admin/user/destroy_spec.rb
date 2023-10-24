require "rails_helper"

RSpec.shared_examples "cannot delete admins" do
  it "does not allow destroying admins" do
    expect do
      delete admin_user_path(admin.id)
    end.not_to change(Administrator, :count)
  end
end

RSpec.shared_examples "cannot delete moderators" do
  it "does not allow destroying moderators" do
    expect do
      delete admin_user_path(moderator.id)
    end.not_to change(Moderator, :count)
  end
end

RSpec.shared_examples "cannot delete passcode users" do
  it "does not allow destroying passcode users" do
    user
    expect do
      delete admin_user_path(user.id)
    end.not_to change(User, :count)
  end
end

RSpec.shared_examples "can delete passcode users" do
  it "allows deleting passcode users" do
    user
    expect do
      delete admin_user_path(user.id)
    end.to change(User, :count).by(-1)
  end
end


RSpec.describe "Admin/user#destroy", type: :request do
  let!(:admin) { create(:administrator).user }
  let!(:moderator) { create(:moderator).user }
  let(:user) { create(:user) }
  let!(:several_users) { create_list(:user, 5) }

  before do
    unless RSpec.current_example.metadata[:no_login_required]
      login_as(current_user)
    end
  end

  context "when admin" do
    let(:current_user) { create(:administrator).user }

    include_examples "cannot delete admins"

    it "allows destroying moderators" do
      expect do
        delete admin_user_path(moderator.id)
      end.to change(Moderator, :count).by(-1)
    end

    include_examples "can delete passcode users"
  end

  context "when moderator" do
    let(:current_user) { create(:moderator).user }

    include_examples "cannot delete admins"
    include_examples "cannot delete moderators"
    include_examples "cannot delete passcode users"
  end

  context "when passcode user" do
    let(:current_user) { create(:user) }

    include_examples "cannot delete admins"
    include_examples "cannot delete moderators"
    include_examples "cannot delete passcode users"
  end

  context "when guest", :no_login_required do
    include_examples "cannot delete admins"
    include_examples "cannot delete moderators"
    include_examples "cannot delete passcode users"
  end
end
