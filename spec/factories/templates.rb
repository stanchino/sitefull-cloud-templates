FactoryGirl.define do
  factory :template do
    name Faker::Lorem.sentence
    script Faker::Lorem.paragraph
  end
end
