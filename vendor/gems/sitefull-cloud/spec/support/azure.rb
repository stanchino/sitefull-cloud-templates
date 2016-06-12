require 'azure_mgmt_compute'
require 'azure_mgmt_network'
require 'azure_mgmt_resources'
require 'azure_mgmt_storage'

RSpec.configure do |config|
  config.before(:each) do
    regions = double(resource_types: [double(resource_type: 'virtualMachines', locations: ['West US', 'East US'])])
    allow_any_instance_of(::Azure::ARM::Resources::ResourceManagementClient).to receive_message_chain(:providers, :get).and_return(regions)

    machine_types = double(value: [double(name: 'Basic_A0'), double(name: 'Basic_A1')])
    allow_any_instance_of(::Azure::ARM::Compute::ComputeManagementClient).to receive_message_chain(:virtual_machine_sizes, :list).and_return(machine_types)

    images = [double(name: 'image_1'), double(name: 'image_2')]
    allow_any_instance_of(::Azure::ARM::Compute::ComputeManagementClient).to receive_message_chain(:virtual_machine_images, :list_skus).and_return(images)
  end
end
