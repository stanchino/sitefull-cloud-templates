require 'rails_helper'

RSpec.describe DeploymentJob, type: :job do
  describe 'perform' do
    let(:deployment) { FactoryGirl.create(:deployment) }
    let(:vpc_id) { 'vpc-id' }
    let(:route_table_id) { 'route-table-id' }
    let(:group_id) { 'group-id' }
    before do
      allow_any_instance_of(Aws::EC2::Client).to receive(:run_instances).and_return(double(instances: [double(instance_id: 'instance_id')]))
      allow_any_instance_of(Aws::EC2::Client).to receive(:create_vpc).and_return(double(vpc: double(vpc_id: vpc_id, tags: [])))
      allow_any_instance_of(Aws::EC2::Client).to receive(:describe_route_tables).and_return(double(route_tables: [double(vpc_id: vpc_id, route_table_id: route_table_id, tags: [])]))
      allow_any_instance_of(Aws::EC2::Client).to receive(:describe_security_groups).and_return(double(security_groups: [double(vpc_id: vpc_id, group_id: group_id, tags: [])]))
    end
    Sidekiq::Testing.inline! do
      context 'with existing internet gateway' do
        let(:internet_gateway_id) { 'internet-gateway-id' }
        before do
          allow_any_instance_of(Aws::EC2::Client).to receive(:describe_internet_gateways).and_return(double(internet_gateways: [double(internet_gateway_id: internet_gateway_id, attachments: [double(vpc_id: vpc_id)])]))
        end
        it 'does not create a new gateway' do
          expect(subject.perform(deployment.id)).to be_truthy
          expect_any_instance_of(Aws::EC2::Client).not_to receive(:create_internet_gateway)
        end
      end

      context 'without internet gateway' do
        it { expect(subject.perform(deployment.id)).to be_truthy }
      end
    end
  end
end
