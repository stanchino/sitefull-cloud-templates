namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = Dir['spec/*/**/*_spec.rb'].reject { |f| f['/requests'] || f['/features'] }
    t.verbose = false
  end

  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/requests/**/*_spec.rb'
    t.verbose = false
  end

  RSpec::Core::RakeTask.new(:feature) do |t|
    t.pattern = 'spec/features/**/*_spec.rb'
    t.verbose = false
  end
end
