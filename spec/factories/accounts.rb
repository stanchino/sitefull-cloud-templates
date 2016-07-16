# frozen_string_literal: true
FactoryGirl.define do
  factory :account, aliases: [:current_account] do
    name 'MyString'
    organization
  end
end
