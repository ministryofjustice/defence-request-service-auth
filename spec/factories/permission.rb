FactoryGirl.define do
  factory :permission do
    association :user
    association :role
    association :application, factory: :oauth_application

    trait :with_organisation do
      association :organisation
    end
  end
end
