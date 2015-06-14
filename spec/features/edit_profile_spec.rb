require "rails_helper"

RSpec.feature "Editing a profile" do
  let(:organisation) { create :organisation }
  let!(:user) { create(:user, profile: users_profile) }
  let(:users_profile) { create(:profile, organisations: [organisation]) }

  before do
    login_as_user user.email, user.password
  end

  context "as a User that owns the Profile" do
    specify "can change my own information" do
      new_profile = FactoryGirl.build :profile

      fill_in_edit_profile_form_with users_profile, new_profile

      click_button "Update Profile"

      assert_profile_rendered new_profile
    end

    specify "go to the page to change my password" do
      visit edit_profile_path(users_profile)

      within "form.edit_profile" do
        click_link "Change Password"
      end

      expect(current_path).to eq(edit_user_path(users_profile.user))
    end
  end

  context "as a User with an admin permission for the organisation the Profile belongs to" do
    let!(:admin_role) { Role.where(name: "admin").first_or_create! }
    let!(:profile) { create(:profile, organisations: [organisation]) }

    before do
      create :permission, user: user, role: admin_role, organisation: organisation
    end

    specify "Editing a Profile that cannot log in" do
      new_profile = FactoryGirl.build :profile

      fill_in_edit_profile_form_with profile, new_profile

      click_button "Update Profile"

      assert_profile_rendered new_profile
      expect(page).to have_content("This user cannot login")
    end

    specify "Edit a Profile to add a password so the user can log in", js: true do
      new_profile = FactoryGirl.build :profile
      new_user = FactoryGirl.build :user

      fill_in_edit_profile_form_with profile, new_profile

      check "Can login?"
      fill_in "Password", with: new_user.password
      fill_in "Password confirmation", with: new_user.password

      click_button "Update Profile"

      assert_profile_rendered new_profile
      expect(page).to have_content("This user can login")
    end

    specify "Edit a Profile to change an existing password redirects to user edit page" do
      profile = create :profile, :with_user, organisations: [organisation]

      visit profiles_path
      within "tr#profile_#{profile.id}" do
        click_link "Edit"
      end

      within "form.edit_profile" do
        click_link "Change Password"
      end

      expect(current_path).to eq(edit_user_path(profile.user))
    end

    specify "errors are shown if a profile cannot be updated" do
      new_profile = FactoryGirl.build :profile, name: ""

      fill_in_edit_profile_form_with profile, new_profile

      click_button "Update Profile"

      expect(page).to have_content "You need to fix the errors on this page before continuing"
      expect(page).to have_content "Name: can't be blank"
    end
  end

  context "as a User without an admin permission trying to edit another Users profile" do
    let!(:profile) { create(:profile, organisations: [organisation]) }

    specify "gets redirected back to the root_path with an error message" do
      visit edit_profile_path(profile)

      expect(current_path).to eq(root_path)
      expect(page).to have_content "You are not authorized to do that"
    end
  end
end


