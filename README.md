# Manage your own cloud deployments online

[![Build
Status](https://travis-ci.org/stanchino/sitefull-cloud-deploy.svg?branch=master)](https://travis-ci.org/stanchino/sitefull-cloud-deploy)
[![Code
Climate](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/badges/gpa.svg)](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy)
[![Test
Coverage](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/badges/coverage.svg)](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/coverage)
[![Issue Count](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/badges/issue_count.svg)](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy)
[![Dependency Status](https://www.versioneye.com/user/projects/56ebab9a4e714c004f4d0c71/badge.svg?style=flat)](https://www.versioneye.com/user/projects/56ebab9a4e714c004f4d0c71)

A [Ruby on Rails](http://rubyonrails.com) application for automating your cloud deployments.

Spin up your own instance
=========================
If you want to test the applicatiion you can deploy it to your [Heroku](https://www.heroku.com/) account using the [Deploy to Heroku](https://devcenter.heroku.com/articles/heroku-button) button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Contributing
============
If you want to contribute to the project please read the following sections carefully.

Recommended development environment
-----------------------------------

### For Mac users:
 * [Xcode with command line tools](http://railsapps.github.io/xcode-command-line-tools.html)
 * [Hombrew](http://mxcl.github.com/homebrew/)
 * [Janus](https://github.com/carlhuda/janus)
 * [iTerm](http://www.iterm2.com/#/section/home)
 * [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh)

Prerequisites
-------------
 * A running [PostgreSQL](http://www.enterprisedb.com/products-services-training/pgdownload) database server.
 * [RVM](https://rvm.io) installed as described [here](https://rvm.io/install) to manage the [Ruby](https://ruby-lang.org) version.
 * The [PhantomJS](http://phantomjs.org/) headless WebKit engine [installed](http://phantomjs.org/download.html) to run the feature tests.
 * A local [Redis](http://redis.io) [installation](http://redis.io/topics/quickstart) for processing background jobs.

Project Set Up
-------------
 * Download the project code from [GitHub](https://github.com/stanchino/sitefull-cloud-deploy):
```
# git clone git@github.com:stanchino/sitefull-cloud-deploy.git
```
 * Install [Ruby](https://www.ruby-lang.org/):
```
# cd sitefull-cloud-deploy
# rvm install ruby-2.3.0
```
 * Install [bundler](http://bundler.io/#getting-started):
```
# gem install bundler
```
 * Install [third party](#third-party-modules) modules dependencies:
```
# bundle install
```
 * Start the [Redis](http://redis.io) server
```
# redis-server &
```
or
```
# service redis start
```
depending on your local environment
 * Initialize the development and test databases:
```
# rake db:create db:schema:load
# rake db:create db:test:prepare RAILS_ENV=test
```
 * **Optional**: Seed the database with sample data:
```
# rake db:seed
```
 * Install the [foreman](http://ddollar.github.io/foreman/) Procfile-based manager:
```
# gem install foreman
```
 * Create an encryption key and add it to your `.env` file
```
# echo "ENC_KEY=`rake secret`" >> .env
```
 * Setup a new [AWS user](https://console.aws.amazon.com/iam/home#users) and add the access key id, secret access key and the default region envionment variables to your `.env` file
```
# echo "AWS_ACCESS_KEY_ID={your-access-key-id}" >> .env
# echo "AWS_SECRET_ACCESS_KEY={your-secret-access-key}" >> .env
# echo "AWS_REGION={default-region}" >> .env
```
the AWS credentials are going to be used for uploading the template scripts to [Amazon S3](https://console.aws.amazon.com/s3/home) and the user will need to have access to your S3 account.
 * Start the server:
```
# foreman start
```
**NOTE** Make sure your local [PostgreSQL](http://www.postgresql.org/docs/9.5/static/server-start.html) and [Redis](http://redis.io/topics/quickstart#starting-redis) servers are up and running before starting the application server.

Guidelines
----------
We use [CodeClimate](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy) for code quality analysis. Every time a pull request is created the quality of the code is determined and reported in GitHub. Coding standards compliance can be tested locally once the project is [setup](#project-set-up) using [Rubocop](https://github.com/bbatsov/rubocop#installation):
```
# gem install rubocop
# rubocop
```

You can also check the [Code Climate CLI](https://github.com/codeclimate/codeclimate) tool and use it to analyze your code quality locally before creating a pull request:
```
# cd sitefull-cloud-deploy
# codeclimate analyze -e scss-lint -e eslint -e coffelint -e brakeman -e bundler-audit -e rubocop .
```
**NOTE** The `duplication` engine takes quite some time to process the application code but you can still run it locally before submitting a pull request:
```
# codeclimate analyze -e duplication .
```

Testing
-------
The following tools are used for testing the application:
  * [Rspec](http://rspec.info/) as the testing framework
  * [Capybara](http://jnicklas.github.io/capybara/) for features tests

To run all the tests execute
```
# rake spec
```
**NOTE** Make sure your local [PostgreSQL](http://www.postgresql.org/docs/9.5/static/server-start.html) and [Redis](http://redis.io/topics/quickstart#starting-redis) servers are up and running before running the tests.

The tests are split into three groups: *unit tests*, *integration tests* and *feature tests*. Each one can be executed using the following commands:
```
# rake spec:unit
# rake spec:integration
# rake spec:feature
``` 

The application uses [simplecov](https://github.com/colszowka/simplecov) to generate code coverage statistics. It is available in the `coverage/` directory. The goal is to maintain the code coverage at **100%** so be carefull when adding new features and check the test coverage report before creating a pull request.

#### Useful Resources
 * [betterspecs.org](http://betterspecs.org)
 * [Thoughtbot's thoughts](https://robots.thoughtbot.com/tags/rspec)
 * [Relish](https://www.relishapp.com/rspec/)
  * [Model Specs](https://www.relishapp.com/rspec/rspec-rails/docs/model-specs)
  * [Controller Specs](https://www.relishapp.com/rspec/rspec-rails/docs/controller-specs)
  * [Request Specs](https://www.relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec)
  * [Feature Specs](https://www.relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec)
  * [View Specs](https://www.relishapp.com/rspec/rspec-rails/docs/view-specs)
  * [Helper Specs](https://www.relishapp.com/rspec/rspec-rails/docs/helper-specs)
  * [Mailer Specs](https://www.relishapp.com/rspec/rspec-rails/docs/mailer-specs)
  * [Routing Specs](https://www.relishapp.com/rspec/rspec-rails/docs/routing-specs)

Managing Tasks
--------------
The project uses [Pivotal Tracker](https://www.pivotaltracker.com) for task management. The SCRUM iteration for the project is one week and the backlog is populated and prioritized on Sunday before the Sprint starts. The recommended steps when working on project tasks is the following:
 * When you start working on a Task change the task status to started in [Pivotal](https://www.pivotaltracker.com/n/projects/1521509).
 * Create a branch from development that starts with the task ID and shortly describes the task you will be working on, eg.
```
# git checkout -b 112745179_switch_to_postgresql
```
 * Once you are done with the task you are working on create a pull request and include one of the "fixed", "completed" or "finished" keywords together with the story ID in square brackets. This will
automatically update the story status in [Pivotal](www.pivotaltracker.com) from "Started" to "Finished" when the pull request is merged

### Pivotal Task Lanes
* *Icebox*: Tasks in the Icebox lane are not yet prioritized and will most likely be added to the Backlog lane sooner or later.
* *Backlog*: Tasks in the Backlog lane are prioritized and available for you to work on. Each task in the Backlog should have story points.
* *Current*: Tasks in this lane are currently being worked on. Each task should have **both** story points and someone assigned to it.

### Task Status
* *Unstarted*: This task hasn't been started yet and is available for you to pick.
* *Started* This task is currently being worked on by someone.
* *Finished* This task is completed and the code is merged to the development branch but it is not yet deployed to staging for testing.
* *Delivered*: This task is deployed to staging and readu to be tested. Once the story is tested it can be set to either "Accepted" or "Rejected".
* *Rejected*: This task is **not** done or there are regression issues with the task. In this case the task should be restarted.
* *Accepted*: This task is done.

Management tools
================
The application uses [Sidekiq](http://sidekiq.org/) for background jobs processing and exposes the native Sidekiq Web UI under `/sidekiq`.

Application Lifecycle
=====================
There are three different application environments following the standard lifecycle managment process: **development**, **staging** and **production**.

Development Environment
-----------------------
This environment uses the `development` branch and includes [Pivotal](https://www.pivotaltracker.com/n/projects/1521509) tasks that are finished and ready for adding to the release but are not tested yet.

Staging Environment
-------------------
This environment uses the `staging` branch and a copy of the production database. It contains the features that are going to be included in the release. This environment is intended for testing [Pivotal](https://www.pivotaltracker.com/n/projects/1521509) tasks as described in the [Managing Tasks](#managing-tasks) section.

Production Environment
----------------------
This environment uses the `master` branch and includes the latest stable version of the application features that are publicly available.

The production URL for the application is currently setup to [cloud.sitefull.com](http://cloud.sitefull.com) and is deployed to [Heroku](https://heroku.com).

Release Process
===============
Development Environment
-----------------------
When a task is completed the pull request for the task implementation is merged to the `development` branch. When the [TravisCI](https:/travis-ci.org) and [CodeClimate](https://codeclimate.com) checks are passed the `development` branch is automatically deployed to [Heroku](https://heroku.com).

A deployment of the `development` branch is available at [sitefull-dev.herokuapp.com](http://sitefull-dev.herokuapp.com).

Staging Environment
-------------------
When features from the `development` branch are ready to be released the branch is merged to `staging`. When the [TravisCI](https:/travis-ci.org) and [CodeClimate](https://codeclimate.com) checks are passed the `staging` branch is automatically deployed to [Heroku](https://heroku.com).

The staging URL is currently set to [sitefull-stg.herokuapp.com](http://sitefull-stg.herokuapp.com).

Production Environment
----------------------
When all features deployed to the [staging environment](#staging-environment) are tested and accepted in [Pivotal](https://www.pivotaltracker.com) the `staging` branch is merged to `master`. When the [TravisCI](https:/travis-ci.org) and [CodeClimate](https://codeclimate.com) checks are passed the `master` branch is automatically deployed to [Heroku](https://heroku.com).

The production URL is currently set to [cloud.sitefull.com](http://cloud.sitefull.com).

Third Party Modules
===================
The application uses the following languages to speed up the development process:
  * [Slim Template Engine](http://slim-lang.com/) for the views
  * [CoffeeScript](http://coffeescript.org/) as a replacement for JavaScript
  * [Sass](http://sass-lang.com/) as the underlying CSS framework

And some thrid party tools which are useful for creating a good looking user experience:
  * [Bootstrap](http://getbootstrap.com/)
  * [FontAwesome](https://fortawesome.github.io/Font-Awesome/)
  * [jQuery](https://jquery.com/)

The full list of modules added to the `Gemfile` is:
  * [acts-as-taggable-on](https://github.com/mbleigh/acts-as-taggable-on) In order to use tags for deployment templates.
  * [attr_encrypted](https://github.com/attr-encrypted/attr_encrypted) Encrypt attributes when saving cloud provider credentials, etc.
  * [aws-sdk](https://github.com/aws/aws-sdk-ruby) The Amazon SDK for Ruby module.
  * [database_cleaner](https://github.com/DatabaseCleaner/database_cleaner) Cleans up the database when running the tests.
  * [bootstrap-sass](https://github.com/twbs/bootstrap-sass) Allows for integrating the [Bootstrap](http://getbootstrap.com) framework.
  * [cancancan](https://github.com/CanCanCommunity/cancancan) A very good authorization module.
  * [capybara](https://github.com/jnicklas/capybara) To write feature tests.
  * [capybara-email](https://github.com/dockyard/capybara-email) To open email messages when running feature tests.
  * [capybara-screenshot](https://github.com/mattheworiordan/capybara-screenshot) Creates screenshots when feature tests are failing.
  * [codeclimate-test-reporter](https://github.com/codeclimate/ruby-test-reporter) Generates [CodeClimate](https://codeclimate.com/) reports for the code quality and test coverage.
  * [devise](https://github.com/plataformatec/devise) For authenticating users.
  * [dotenv-rails](https://github.com/bkeepers/dotenv) loads environment variables from the `.env` file on `development`.
  * [factory_girl_rails](https://github.com/thoughtbot/factory_girl_rails) To simplify object creation.
  * [faker](https://github.com/stympy/faker) Useful for generating random data especially when used in tests.
  * [font-awesome-rails](https://github.com/bokmann/font-awesome-rails) [FontAwesome](https://fortawesome.github.io/Font-Awesome/) icons.
  * [jbuilder](https://github.com/rails/jbuilder) Building JSON responses in a more efficient way.
  * [jquery-rails](https://github.com/rails/jquery-rails) Adds jQuery to the application.
  * [letter_opener](https://github.com/ryanb/letter_opener) To avoid sending email messages when running in `development` mode.
  * [net-ssh](https://github.com/net-ssh/net-ssh) Used for connecting to the instances and executing the script.
  * [pg](https://bitbucket.org/ged/ruby-pg/wiki/Home) For database connections.
  * [poltergeist](https://github.com/teampoltergeist/poltergeist) Use Poltergeist for feature tests.
  * [pry-rails](https://github.com/rweng/pry-rails) Use [Pry](http://pryrepl.org/) as an alternative to the standard IRB Ruby shell. 
  * [quiet_assets](https://github.com/evrone/quiet_assets) To skip logging assets and polluting the logs.
  * [rspec-activemodel-mocks](https://github.com/rspec/rspec-activemodel-mocks) Allows for mocking ActiveModel objects in tests.
  * [rspec-collection_matchers](https://github.com/rspec/rspec-collection_matchers) Usefull for matching collections in your tests.
  * [rspec-rails](https://github.com/rspec/rspec-rails) The [RSpec](http://rspec.info/) testing framework for BDD.
  * [select2-rails](https://github.com/argerim/select2-rails) Autocomplete and tags support.
  * [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) Simplify writing tests big time as discussed on the official [shoulda matchers](http://matchers.shoulda.io/) page.
  * [sidekiq](https://github.com/mperham/sidekiq) Sidekiq is used for processing background jobs across the application.
  * [sidekiq-failures](https://github.com/mhfs/sidekiq-failures) Keep track of Sidekiq failed jobs.
  * [simple_form](https://github.com/plataformatec/simple_form) For handling forms.
  * [simplecov](https://github.com/colszowka/simplecov) Generates code coverage reports when running the tests.
  * [sinatra](https://github.com/sinatra/sinatra) Required for the Sidekiq monitoring interface [https://github.com/mperham/sidekiq/wiki/Monitoring](https://github.com/mperham/sidekiq/wiki/Monitoring).
  * [sitefull-cloud](https://github.com/stanchino/sitefull-cloud) The core module used to provision new instances and manage cloud provider options (regions, machine types, images, etc.).
  * [slim](https://github.com/slim-template/slim) The template engine.
  * [slim-rails](https://github.com/slim-template/slim-rails) Rails implementation of the [Slim](http://slim-lang.org) template engine.
  * [unicorn](http://unicorn.bogomips.org/) To run the application server.
  * [wisper](https://github.com/krisleech/wisper) A micro library providing Ruby objects with Publish-Subscribe capabilities.
  * [wisper-rspec](https://github.com/krisleech/wisper-rspec) Rspec matchers and stubbing for Wisper.
  * [wispre-sidekiq](https://github.com/krisleech/wisper-sidekiq) Asynchronous event publishing for Wisper using Sidekiq.
