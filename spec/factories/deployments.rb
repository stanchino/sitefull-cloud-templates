FactoryGirl.define do
  factory :deployment do
    template

    trait :aws do
      provider_type 'aws'
      region 'us-east-1'
      flavor 't2.micro'
      image 'image-id'
      access_key_id Faker::Internet.password
      secret_access_key Faker::Internet.password
    end

    trait :google do
      provider_type 'google'
      region 'us-central1-a'
      flavor 'machine-type-1'
      image 'image-id-1'
      google_auth '{}'
    end
  end
end
