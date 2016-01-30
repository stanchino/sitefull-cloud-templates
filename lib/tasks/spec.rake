namespace :spec do
  begin
    require 'rspec/core/rake_task'

    desc 'Run unit tests only'
    RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = Dir['spec/*/**/*_spec.rb'].reject { |f| f['/requests'] || f['/features'] }
      t.verbose = false
    end

    desc 'Run integration tests only'
    RSpec::Core::RakeTask.new(:integration) do |t|
      t.pattern = 'spec/requests/**/*_spec.rb'
      t.verbose = false
    end

    desc 'Run feature tests only'
    RSpec::Core::RakeTask.new(:feature) do |t|
      t.pattern = 'spec/features/**/*_spec.rb'
      t.verbose = false
    end
  rescue LoadError
    Rails.logger.info 'Unable to load tasks'
  end
end
