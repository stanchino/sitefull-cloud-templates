RSpec.configure do |config|
  config.before(:each) do
    regions = double(regions: [double(region_name: 'us-east-1')])
    allow_any_instance_of(Aws::EC2::Client).to receive(:describe_regions).and_return(regions)
  end
end
