# frozen_string_literal: true
Sidekiq.configure_server do |config|
  config.failures_max_count = false
end
