require "rails_helper"

RSpec.shared_examples "admin dashboard's basic functions" do
  it "is visible" do
    expect(page).to have_content("Admin dashboard")
  end

  it "is enterable" do
    click_on "Admin dashboard"

    expect(page).to have_content("Admin dashboard")
  end

  context "when displayed" do
    before do
      several_users
      if current_user.admin_role?
        moderator
      elsif current_user.moderator_role?
        admin
      end

      click_on "Admin dashboard"
    end

    it "shows the list of users" do
      expect(page).to have_selector(".user-management-panel", count: several_users.count + 2) # 2: current user + admin/moderator
    end

    it "shows the list of users' corresponding roles" do
      expect(find("main")).to have_content("admin", count: 1)
      expect(page).to have_content("passcode_user", count: several_users.count)

      # one for role, one for dismiss buttons
      expect(page).to have_content("moderator", count: 1)
    end
  end
end

RSpec.shared_examples "admin dashboard access denied" do
  it "is not visible" do
    visit root_path

    expect(page).to have_no_link("users", href: admin_users_path)
  end

  it "throws an error when visit dashboard" do
    visit admin_users_path

    expect(page).to have_content("You are not signed in!").or have_content("You are not authorized to perform this action")
  end
end

RSpec.describe "Admin dashboard", type: :system do
  let(:admin) { create(:administrator).user }
  let(:moderator) { create(:moderator).user }
  let(:user) { create(:user) }
  let(:several_users) { create_list(:user, 5) }

  context "when user is admin" do
    let(:current_user) { create(:administrator).user }

    before do
      visit root_path

      click_on "validate passcode"

      fill_in "Passcode", with: current_user.passcode
      click_on "Save"
    end

    include_examples "admin dashboard's basic functions"

    context "when doing admin-specific actions" do
      it "shows appropriate buttons for every role" do
        several_users; moderator; current_user

        click_on "Admin dashboard"

        expect(page).to have_button("promote", count: 5)
        expect(page).to have_button("dismiss", count: 1)
      end

      it "shows no delete button for another admin" do
        another_admin = create(:administrator).user

        click_on "Admin dashboard"

        section = find("#user-id-#{another_admin.id}")
        expect(section).to have_no_button("delete_user")
      end
    end
  end

  xcontext "for moderator" do
    # Moderator doesn't have access to admin's dashboard basic functions
    let(:current_user) { create(:moderator).user }
    include_examples "admin dashboard's basic functions"
  end

  context "when user has passcode rights" do
    let (:current_user) { create(:user) }

    before do
      visit root_path

      click_on "validate passcode"

      fill_in "Passcode", with: current_user.passcode
      click_on "Save"
    end

    include_examples "admin dashboard access denied"
  end

  context "when user is a guest" do
    include_examples "admin dashboard access denied"
  end
end
