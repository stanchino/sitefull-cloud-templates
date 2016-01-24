FactoryGirl.define do
  factory :user do
    before(:create, &:skip_confirmation!)
    after(:create, &:confirm)
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.email
    password 'secretpass'
    password_confirmation 'secretpass'
  end
end
