FactoryGirl.define do
  factory :deployment do
    provider Deployment::PROVIDERS.sample
    image 'MyString'
    flavor 'MyString'
    template
  end
end
