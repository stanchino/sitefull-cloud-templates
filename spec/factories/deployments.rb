FactoryGirl.define do
  factory :deployment do
    template
    token '{"access_key": "access_key"}'

    trait :amazon do
      provider_type 'amazon'
      region 'us-east-1'
      flavor 't2.micro'
      image 'image-id'
      role_arn 'role'
    end

    trait :google do
      provider_type 'google'
      region 'us-central1-a'
      flavor 'machine-type-1'
      image 'image-id-1'
      project_name 'project'
    end

    trait :azure do
      provider_type 'azure'
      region 'us'
      flavor 'machine-type-a'
      image 'image-id-a'
      subscription_id 'subscription_id'
    end
  end
end
