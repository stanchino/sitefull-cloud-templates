FactoryGirl.define do
  factory :deployment do
    provider_type 'aws'
    region 'us-east-1'
    flavor 't2.micro'
    image 'image-id'
    access_key_id Faker::Internet.password
    secret_access_key Faker::Internet.password
    template
  end
end
