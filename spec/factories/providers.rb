# frozen_string_literal: true
FactoryGirl.define do
  factory :provider do
    sequence(:name) { |n| "Provider #{n}" }
    sequence(:textkey) { |n| Sitefull::Cloud::Provider::PROVIDERS[n % 3] }
    configured true
    organization

    trait :amazon do
      textkey 'amazon'
    end

    trait :google do
      textkey 'google'
    end

    trait :azure do
      textkey 'azure'
    end
  end
end
