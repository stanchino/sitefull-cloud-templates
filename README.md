# Manage your own cloud deployments online

[![Build
Status](https://travis-ci.org/stanchino/sitefull-cloud-deploy.svg?branch=master)](https://travis-ci.org/stanchino/sitefull-cloud-deploy)
[![Code
Climate](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/badges/gpa.svg)](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy)
[![Test
Coverage](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/badges/coverage.svg)](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/coverage)
[![Issue
Count](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy/badges/issue_count.svg)](https://codeclimate.com/github/stanchino/sitefull-cloud-deploy)

A [Ruby on Rails](http://rubyonrails.com) application for automating your cloud deployments using [Cloud-Init](https://cloudinit.readthedocs.org/en/latest/) scripts.

Contributing
============
If you want to contribute to the project please read the following sections carefully.

Recommended development environment
-----------------------------------

### For Mac users:
 * Latest Xcode with command line tool installed
 * [Hombrew](http://mxcl.github.com/homebrew/)
 * [Janus](https://github.com/carlhuda/janus)
 * [iTerm](http://www.iterm2.com/#/section/home)
 * [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh)

Prerequisites
-------------
 * A running [PostgreSQL](http://www.enterprisedb.com/products-services-training/pgdownload) database server.
 * [RVM](https://rvm.io) installed as described [here](https://rvm.io/install) to manage the [Ruby](https://ruby-lang.org) version.
 * The [PhantomJS](http://phantomjs.org/) headless WebKit engine [installed](http://phantomjs.org/download.html) to run the feature tests.

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
 * Start the server:
```
# foreman start
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

The tests are split into three groups: *unit tests*, *integration tests* and *feature tests*. Each one can be executed using the following commands:
```
# rake spec:unit
# rake spec:integration
# rake spec:feature
``` 

The application uses [simplecov](https://github.com/colszowka/simplecov) to generate code coverage statistics. It is available in the `coverage/` directory. The goal is to maintain the code coverage **for each** of the *unit*, *integration* and *feature* test suites at **100%** so be carefull when adding new features.

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

Deployment
==========
There are three different application states being deployed following the standard lifecycle managment process: **development**, **staging** and **production**.

Development Environment
-----------------------
The **development environment** uses the latest `development` branch and represents work that is currently being finished but is not tested yet. It is deployed to [Heroku](https://heroku.com) and is available at [sitefull-dev.herokuapp.com](http://sitefull-dev.herokuapp.com). You can also spin up your own copy of the `development` branch using the [Deploy to Heroku](https://devcenter.heroku.com/articles/heroku-button) button below:
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Staging Environment
-------------------
The **staging environment** is a copy of the **production environment** data with the latest changes that are going to be included in the next application release. It is intended for testing work that is finished and accepting/rejecting [Pivotal](https://www.pivotaltracker.com/n/projects/1521509) tasks as described in the [Managing Tasks](#managing-tasks) section. The staging environment is currently deployed to [Heroku](https://heroku.com) at [sitefull-stg.herokuapp.com](http://sitefull-stg.herokuapp.com).

Production Environment
----------------------
The **production environment** contains the latest code from the `master` branch and is the final version of the application that reflects the latest release. The production URL for the application is currently setup to [cloud.sitefull.com](http://cloud.sitefull.com) and is deployed to [Heroku](https://heroku.com).

## Third Party Modules
The application uses the following languages to speed up the development process:
  * [Slim Template Engine](http://slim-lang.com/) for the views
  * [CoffeeScript](http://coffeescript.org/) as a replacement for JavaScript
  * [Sass](http://sass-lang.com/) as the underlying CSS framework

And some thrid party tools which are useful for creating a good looking user experience:
  * [Bootstrap](http://getbootstrap.com/)
  * [FontAwesome](https://fortawesome.github.io/Font-Awesome/)
  * [jQuery](https://jquery.com/)

The full list of modules added to the `Gemfile` is:
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
  * [fog](https://github.com/fog/fog) For managing your cloud deployments behind the scenes.
  * [font-awesome-rails](https://github.com/bokmann/font-awesome-rails) [FontAwesome](https://fortawesome.github.io/Font-Awesome/) icons.
  * [jbuilder](https://github.com/rails/jbuilder) Building JSON responses in a more efficient way.
  * [jquery-rails](https://github.com/rails/jquery-rails) Adds jQuery to the application.
  * [letter_opener](https://github.com/ryanb/letter_opener) To avoid sending email messages when running in `development` mode.
  * [mysql2](https://github.com/brianmario/mysql2) For establishing database connections.
  * [poltergeist](https://github.com/teampoltergeist/poltergeist) Use Poltergeist for feature tests.
  * [quiet_assets](https://github.com/evrone/quiet_assets) To skip logging assets and polluting the logs.
  * [pry-rails](https://github.com/rweng/pry-rails) Use [Pry](http://pryrepl.org/) as an alternative to the standard IRB Ruby shell. 
  * [rspec-rails](https://github.com/rspec/rspec-rails) The [RSpec](http://rspec.info/) testing framework for BDD.
  * [rspec-collection_matchers](https://github.com/rspec/rspec-collection_matchers) Usefull for matching collections in your tests.
  * [rspec-activemodel-mocks](https://github.com/rspec/rspec-activemodel-mocks) Allows for mocking ActiveModel objects in tests.
  * [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) Simplify writing tests big time as discussed on the official [shoulda matchers](http://matchers.shoulda.io/) page.
  * [simple_form](https://github.com/plataformatec/simple_form) For handling forms.
  * [simplecov](https://github.com/colszowka/simplecov) Generates code coverage reports when running the tests.
  * [slim](https://github.com/slim-template/slim) The template engine.
  * [slim-rails](https://github.com/slim-template/slim-rails) Rails implementation of the [Slim](http://slim-lang.org) template engine.
  * [unicorn](http://unicorn.bogomips.org/) To run the application server.
