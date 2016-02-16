FactoryGirl.define do
  factory :template do
    sequence(:name) { Faker::Lorem.sentence }
    os 'debian' # Template::OPERATING_SYSTEMS.sample.first
    script Faker::Lorem.paragraph
    tag_list Array.new(3) { Faker::Lorem.word }.join(',')
    user
  end
end
