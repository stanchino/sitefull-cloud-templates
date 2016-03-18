# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.where(first_name: 'Chuck', last_name: 'Norris', admin: true, email: 'admin@sitefull.com').first_or_initialize.tap do |user|
  user.password = user.password_confirmation = 'asdfasdf'
  user.skip_confirmation!
  user.save!
  user.confirm
end

johndoe = User.where(first_name: 'John', last_name: 'Doe', email: 'john.doe@sitefull.com').first_or_initialize.tap do |user|
  user.password = user.password_confirmation = 'asdfasdf'
  user.skip_confirmation!
  user.save!
  user.confirm
end

johndoe.templates.create!(
  name: 'Test',
  os: 'debian',
  tag_list: 'debian,test',
  script: 'test'
)
