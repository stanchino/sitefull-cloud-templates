FactoryGirl.define do
  factory :credential do
    token 'mytoken'
    provider
    account

    trait :amazon do
      role_arn 'role'
      session_name 'session_id'
    end

    trait :google do
      project_name 'project'
    end

    trait :azure do
      subscription_id 'subscription_id'
    end
  end
end