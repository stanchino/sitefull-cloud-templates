source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails'

# Use PostgreSQL as the database engine
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
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
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc'

# Use ActiveModel has_secure_password
# gem 'bcrypt'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use CanCanCan for authorization
gem 'cancancan'
# Use Devise for authentication
gem 'devise'

# Tag deployment templates
gem 'acts-as-taggable-on'

# Use Select2 for autocomplete and tags
gem 'select2-rails'

# Encrypt and decrpyt attributes
gem 'attr_encrypted'

# Background processing
gem 'sidekiq'
# Keep track of Sidekiq failed jobs
gem 'sidekiq-failures'
# The Sidekiq UI
gem 'sinatra', require: nil

# Pub/Sub implementation
gem 'wisper'
# Asynchronous processing for Pub/Sub
gem 'wisper-sidekiq'

# The module that will perform cloud operations
gem 'sitefull-cloud'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  # Use Pry as an alternative to the standard IRB Ruby shell
  gem 'pry-rails'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Open email message in browser instead of sending them
  gem 'letter_opener'
  # Remove assets from the logs
  gem 'quiet_assets'
end

group :development, :test do
  # Use database_cleaner to clear the test database when running tests
  gem 'database_cleaner'
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
  # Rspec matcher and stubbing for Wisper.
  gem 'wisper-rspec', require: false
end

group :test do
  # Use Capybara for acceptance tests
  gem 'capybara'
  # Use capybara-email to open messages
  gem 'capybara-email'
  # Create screenshot in acceptance tests
  gem 'capybara-screenshot'
  # Generate CodeClimate reports for the project
  gem 'codeclimate-test-reporter', require: false
  # Use Poltergeist for feature specs
  gem 'poltergeist'
  # Generate code coverage reports
  gem 'simplecov', require: false
  # Use shoulda matchers in specs
  gem 'shoulda-matchers', require: false
end

group :production do
  # Use rails_12factor for Heroku deployments
  gem 'rails_12factor'
end
