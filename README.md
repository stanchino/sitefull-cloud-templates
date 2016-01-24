# Manage your own cloud deployments online

[![Build
Status](https://travis-ci.org/stanchino/sitefull-cloud-deploy.svg?branch=master)](https://travis-ci.org/stanchino/sitefull-cloud-deploy)
[![Code
Climate](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/badges/gpa.svg)](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy)
[![Test
Coverage](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/badges/coverage.svg)](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/coverage)
[![Issue
Count](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/badges/issue_count.svg)](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy)

A [Rails](http://rubyonrails.com) application for automating your cloud
deployments using
[Cloud-Init](https://cloudinit.readthedocs.org/en/latest/)

Contributing
============
This section is the first section in the readme because everyone who contributes code must follow the Passare way. Make sure you understand the process we used to make changes to our code base before even setting up your development environment.

Recommended Dev Box
-------------------

### When using a Mac
* Latest Xcode with command line tool installed
* [Hombrew](http://mxcl.github.com/homebrew/)
* [RVM](https://rvm.io/)
* [Janus](https://github.com/carlhuda/janus)
* [iTerm](http://www.iterm2.com/#/section/home)
* [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh)
* [Postgres](http://www.enterprisedb.com/products-services-training/pgdownload#osx)

Project Set Up
-------------

 * Install [RVM](https://rvm.io/) following the [instructions](https://rvm.io/rvm/install).
```
# \curl -sSL https://get.rvm.io | bash -s stable --ruby
```
 * Download the project code from [GitHub](https://github.com/stanchino/sitefull-cloud-templates)
```
# git clone git@github.com:stanchino/sitefull-cloud-templates.git
```
 * Install [third party](#third-party) dependencies
```
# cd sitefull-cloud-templates
# bundle install
```
**NOTE** Installing the
[capybara-webkit](https://github.com/thoughtbot/capybara-webkit) gem requires that you have
the latest Qt installed and the `qmake` utility configured. You can
follow these [instructions](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit) if the installation fails.
 * Initialize the database
```
# cp config/database.sample.yml config/database.yml
# rake db:create db:migrate db:seed && RAILS_ENV=test rake db:create db:migrate
```
 * Start the server
```
# foreman start
```

Testing
-------
The following tools are used for testing the application:
  * [Rspec](http://rspec.info/) as the testing framework
  * [Capybara](http://jnicklas.github.io/capybara/) for acceptance tests

To run the tests execute
```
# bundle exec rspec
```

## Third Party

The application uses the following languages to simplify our lives:
  * [Slim Template Engine](http://slim-lang.com/) for templates
  * [CoffeeScript](http://coffeescript.org/) that compiles to JavaScript
  * [Sass](http://sass-lang.com/) as the underlying CSS framework

And some thrid party tools which are useful for creating a good looking user experience:
  * [Bootstrap](http://getbootstrap.com/)
  * [FontAwesome](https://fortawesome.github.io/Font-Awesome/)
  * [jQuery](https://jquery.com/)

The full list of modules added to the `Gemfile` is:
  * [bootstrap-sass](https://github.com/twbs/bootstrap-sass) Allows for
    integrating the [Bootstrap](http://getbootstrap.com) framework
  * [cancancan](https://github.com/CanCanCommunity/cancancan) A very
    good authorization module
  * [capybara](https://github.com/jnicklas/capybara) To write acceptance
    tests
  * [capybara-screenshot](https://github.com/mattheworiordan/capybara-screenshot) Creates screenshots when acceptance tests are failing
  * [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) The
    webkit driver for [Capybara](http://jnicklas.github.io/capybara/)
  * [codeclimate-test-reporter](https://github.com/codeclimate/ruby-test-reporter) Generates [CodeClimate](https://codeclimate.com/) reports for the code quality and test coverage
  * [devise](https://github.com/plataformatec/devise) For authenticating
    users
  * [dotenv-rails](https://github.com/bkeepers/dotenv) loads environment variables from the `.env` file on
    `development`
  * [factory_girl_rails](https://github.com/thoughtbot/factory_girl_rails) To simplify object creation
  * [faker](https://github.com/stympy/faker) Useful for generating
    random data especially when used in specs
  * [font-awesome-rails](https://github.com/bokmann/font-awesome-rails)
    Awesome icons
  * [jbuilder](https://github.com/rails/jbuilder) Building JSON
    responses in a more efficient way
  * [jquery-rails](https://github.com/rails/jquery-rails) Adds jQuery to
    the application
  * [letter_opener](https://github.com/ryanb/letter_opener) To avoid
    sending email messages when running in `development` mode
  * [mysql2](https://github.com/brianmario/mysql2) For establishing
    database connections
  * [quiet_assets](https://github.com/evrone/quiet_assets) To skip
    logging assets and polluting the logs
  * [rspec-rails](https://github.com/rspec/rspec-rails) The testing
    framework
  * [rspec-collection_matchers](https://github.com/rspec/rspec-collection_matchers) Usefull for matching collections in your specs
  * [rspec-activemodel-mocks](https://github.com/rspec/rspec-activemodel-mocks) Allows for mocking ActiveModel objects in specs
  * [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
    Simplify writing tests big time as discussed on the official
[shoulda matchers](http://matchers.shoulda.io/) page
  * [simple_form](https://github.com/plataformatec/simple_form) For
    handling forms
  * [simplecov](https://github.com/colszowka/simplecov) Generates code
    coverage reports when running the specs
  * [slim](https://github.com/slim-template/slim) The template engine
  * [slim-rails](https://github.com/slim-template/slim-rails) Rails
    implementation of the [Slim](http://slim-lang.org) template engine
  * [unicorn](http://unicorn.bogomips.org/) To run the application
    server
