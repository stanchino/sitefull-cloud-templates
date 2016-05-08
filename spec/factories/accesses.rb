FactoryGirl.define do
  factory :access do
    token 'mytoken'
    provider
    account
  end
end
