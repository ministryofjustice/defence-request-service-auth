require "rails_helper"

RSpec.describe ProfilePolicy do
  let!(:admin_role) { Role.where(name: "admin").first_or_create! }

  let(:organisation) { FactoryGirl.create :organisation }
  let(:user) { FactoryGirl.create :user }

  before do
    FactoryGirl.create :membership, profile: user.profile, organisation: organisation
  end

  context "profile owner" do
    subject { ProfilePolicy.new user, user.profile }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context "another user in the same organisation" do
    let!(:other_user) { FactoryGirl.create :user }
    subject { ProfilePolicy.new other_user, user.profile }

    before do
      FactoryGirl.create :membership, profile: other_user.profile, organisation: organisation
    end

    it { is_expected.to permit_action(:show) }

    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context "organisation admin" do
    let(:admin_user) { FactoryGirl.create :user }

    subject { ProfilePolicy.new admin_user, user.profile }

    before do
      FactoryGirl.create :membership, profile: admin_user.profile, organisation: organisation
      FactoryGirl.create(:permission,
                         user: admin_user,
                         role: admin_role,
                         organisation: organisation
                        )
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:destroy) }
  end

  context "another user not the same organisation" do
    let!(:other_user) { FactoryGirl.create :user }
    subject { ProfilePolicy.new other_user, user.profile }

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
  end
end
