FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| Faker::Role.by_index n }
  end
end
