FactoryGirl.define do
  factory :provider do
    sequence(:name) { |n| "Provider #{n}" }
    sequence(:textkey) { |n| Sitefull::Cloud::Provider::PROVIDERS[n % 3] }
    configured true
    organization
  end
end
