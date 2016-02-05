FactoryGirl.define do
  factory :deployment do
    provider 'MyString'
    credentials { { foo: :bar }.as_json }
    image 'MyString'
    flavor 'MyString'
    template
  end
end
