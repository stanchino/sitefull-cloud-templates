RSpec.configure do |config|
  config.before(:each) do
    zones = double(items: [double(id: 'us-east-1', name: 'us-east-1')])
    allow_any_instance_of(Google::Apis::ComputeV1::ComputeService).to receive(:list_zones).and_return(zones)

    images = double(items: [double(id: 'image-id', name: 'Image')])
    allow_any_instance_of(Google::Apis::ComputeV1::ComputeService).to receive(:list_images).and_return(images)
  end
end
