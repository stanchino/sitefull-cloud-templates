# frozen_string_literal: true
FactoryGirl.define do
  factory :deployment do
    region 'region-id-1'
    machine_type 'machine-type-id-1'
    image 'image-id-1'
    template
    provider
    accounts_user

    trait :amazon do
      association :provider, factory: [:provider, :amazon]
    end

    trait :google do
      association :provider, factory: [:provider, :google]
    end

    trait :azure do
      association :provider, factory: [:provider, :azure]
    end
  end
end
