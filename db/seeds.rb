# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

def create_user(organization, user_params)
  User.where(user_params).first_or_initialize.tap do |user|
    account = Account.create(name: user.email)
    user.password = user.password_confirmation = 'asdfasdf'
    user.skip_confirmation!
    user.current_account = account
    user.save!
    user.confirm
    user.accounts << account
  end
end

organization = Organization.create name: 'SiteFull'

[%w(Amazon amazon), %w(Google google), %w(Azure azure)].each do |name, key|
  Provider.where(name: name, textkey: key, organization: organization).first_or_create!
end

create_user(organization, first_name: 'Chuck', last_name: 'Norris', admin: true, email: 'admin@sitefull.com')
johndoe = create_user(organization, first_name: 'John', last_name: 'Doe', email: 'john.doe@sitefull.com')

johndoe.templates.create!(
  name: 'Hello World',
  os: 'centos',
  tag_list: 'centos,test',
  script: <<END
#!/bin/bash
echo 'Hello World';
END
)
