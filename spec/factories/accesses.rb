FactoryGirl.define do
  factory :access do
    token 'mytoken'
    provider
    user
  end
end
