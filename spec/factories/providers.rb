FactoryGirl.define do
  factory :provider do
    sequence(:name) { |n| "Provider #{n}" }
    sequence(:textkey) { |n| "provider_#{n}" }
  end
end
