# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    password 'secretpass'
    password_confirmation 'secretpass'
    current_account
    before :create, &:skip_confirmation!
    after :create, &:confirm
    after :create do |user|
      user.accounts << user.current_account
      user.current_account.update_attributes name: user.email
    end
  end
end
