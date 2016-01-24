source 'https://rubygems.org'

gem 'rails', github: "rails/rails", branch: "4-2-stable"

# Use MySQL as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use the Slim template engine
gem 'slim'
# Generate Slim templates when creating views
gem 'slim-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Use the Bootstrap SCSS variant
gem 'bootstrap-sass'
# Use FontAwesome icons
gem 'font-awesome-rails'
# Use jQueryUI controls
# gem 'jquery-ui-rails'
# Use SimpleForm for generating forms
gem 'simple_form'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use CanCanCan for authorization
gem 'cancancan'
# Use Devise for authentication
gem 'devise'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Open email message in browser instead of sending them
  gem 'letter_opener'
  # Remove assets from the logs
  gem 'quiet_assets'
end

group :development, :test do
  # Load enviornment variables from .env
  gem 'dotenv-rails'
  # Create object factories
  gem 'factory_girl_rails'
  # Generate fake data
  gem 'faker'
  # Mock models
  gem 'rspec-activemodel-mocks'
  # Match collection properties in specs
  gem 'rspec-collection_matchers'
  # Use Rspec as the test framework
  gem 'rspec-rails'
end

group :test do
  # Use Capybara for acceptance tests
  gem 'capybara'
  # Create screenshot in acceptance tests
  gem 'capybara-screenshot'
  # Use WebKit as the Capybara acceptance tests engine
  gem 'capybara-webkit'
  # Generate CodeClimate reports for the project
  gem 'codeclimate-test-reporter', require: false
  # Use shoulda matchers in specs
  gem 'shoulda-matchers'
  # Generate code coverage reports
  gem 'simplecov', require: false
end
