web: bundle exec rake db:migrate && bundle exec unicorn -p $PORT --config-file ./config/unicorn.rb --no-default-middleware
websocket: bundle exec rake websocket_rails:start_server
worker: bundle exec sidekiq -C config/sidekiq.yml
