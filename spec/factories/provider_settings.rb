# frozen_string_literal: true
FactoryGirl.define do
  factory :provider_setting do
    sequence(:name) { |n| "setting name #{n}" }
    sequence(:value) { |n| "setting value #{n}" }
    provider
  end
end
