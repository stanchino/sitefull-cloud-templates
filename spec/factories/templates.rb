FactoryGirl.define do
  factory :template do
    sequence(:name) { Faker::Lorem.sentence }
    os Faker::Lorem.word
    script Faker::Lorem.paragraph
    user
  end
end
