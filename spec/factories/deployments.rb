FactoryGirl.define do
  factory :deployment do
    template
    region 'region-id-1'
    machine_type 'machine-type-id-1'
    image 'image-id-1'
    accounts_user

    trait :amazon do
      provider_type 'amazon'
      role_arn 'role'
      session_name 'session_id'
    end

    trait :google do
      provider_type 'google'
      project_name 'project'
    end

    trait :azure do
      provider_type 'azure'
      subscription_id 'subscription_id'
    end
  end
end
