FactoryGirl.define do
  factory :deployment do
    provider Deployment::PROVIDERS.sample
    credentials { { foo: :bar }.as_json }
    image 'MyString'
    flavor 'MyString'
    template
  end
end
