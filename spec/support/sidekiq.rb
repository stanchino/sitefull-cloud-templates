# frozen_string_literal: true
Sidekiq::Testing.inline!

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end
