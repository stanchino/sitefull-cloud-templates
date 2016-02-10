FactoryGirl.define do
  factory :credentials do
    type ''
    user
    trait :aws do
      type 'AwsCredential'
    end
  end
end
