FactoryGirl.define do
  factory :user do |user|
    sequence(:email)            {|n| "barry#{n}@example.com" }
    user.password               "password"
    user.password_confirmation  "password"

    trait :with_profile do
      association :profile
    end

    trait :logged_in_to_applications do
      transient do
        number_of_applications 2
      end

      after(:create) do |created_user, evaluator|
        (1..evaluator.number_of_applications).each do
          application = create :oauth_application
          create :permission, application: application, user: created_user
          create :access_token, application: application, resource_owner_id: created_user.id
        end
      end
    end
  end
end
