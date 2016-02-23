require 'rails_helper'
require 'shared_examples/deployments_controller'

RSpec.describe DeploymentsController, type: :controller do
  login_user

  let(:template) { FactoryGirl.create(:template, user: user) }
  let(:invalid_attributes) { { template_id: '' } }
  let(:valid_session) { {} }

  describe 'with AWS as provider', aws: true do
    let(:deployment) { FactoryGirl.create(:deployment, :aws, template: template) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:deployment, :aws, template: template) }
    let(:vpc_id) { 'vpc-id' }
    let(:route_table_id) { 'route-table-id' }
    let(:group_id) { 'group-id' }

    before do
      allow_any_instance_of(Aws::EC2::Client).to receive(:run_instances).and_return(double(instances: [double(instance_id: 'instance_id')]))
      allow_any_instance_of(Aws::EC2::Client).to receive(:create_vpc).and_return(double(vpc: double(vpc_id: vpc_id, tags: [])))
      allow_any_instance_of(Aws::EC2::Client).to receive(:describe_route_tables).and_return(double(route_tables: [double(vpc_id: vpc_id, route_table_id: route_table_id, tags: [])]))
      allow_any_instance_of(Aws::EC2::Client).to receive(:describe_security_groups).and_return(double(security_groups: [double(vpc_id: vpc_id, group_id: group_id, tags: [])]))
    end

    it_behaves_like 'deployment controller'

    describe 'POST #create' do
      context 'with valid params' do
        context 'with existing internet gateway' do
          let(:internet_gateway_id) { 'internet-gateway-id' }
          before do
            allow_any_instance_of(Aws::EC2::Client).to receive(:describe_internet_gateways).and_return(double(internet_gateways: [double(internet_gateway_id: internet_gateway_id, attachments: [double(vpc_id: vpc_id)])]))
          end
          it 'publish the event' do
            expect do
              post :create, { deployment: valid_attributes, template_id: template.to_param }, valid_session
            end.to broadcast(:deployment_saved)
          end
        end
      end
    end

    describe 'POST #options' do
      context 'with valid provider credentials' do
        describe_regions_exception Aws::EC2::Errors::DryRunOperation
        it_behaves_like 'deployment with valid options response'
      end

      context 'with invalid provider credentials' do
        describe_regions_exception Aws::EC2::Errors::AuthFailure
        it_behaves_like 'deployment with invalid options'
      end

      context 'with generic provider validation failure' do
        before { allow_any_instance_of(Aws::EC2::Client).to receive(:describe_regions).with(dry_run: true).and_raise(StandardError) }
        it_behaves_like 'deployment with invalid options'
      end
    end
  end

  describe 'with Google as provider', google: true do
    let(:project_name) { 'project' }
    let(:deployment) { FactoryGirl.create(:deployment, :google, template: template) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:deployment, :google, template: template).merge(project_name: project_name) }

    before do
      allow_any_instance_of(Google::Apis::ComputeV1::ComputeService).to receive(:get_network).with(project_name, 'sitefull-cloud').and_raise(::Google::Apis::ClientError.new('error'))
      allow_any_instance_of(Google::Apis::ComputeV1::ComputeService).to receive(:insert_network).with(project_name, instance_of(::Google::Apis::ComputeV1::Network)).and_return(double(target_link: 'network_id'))
      allow_any_instance_of(Google::Apis::ComputeV1::ComputeService).to receive(:insert_firewall).with(project_name, instance_of(::Google::Apis::ComputeV1::Firewall)).and_return(nil)
      allow_any_instance_of(Google::Apis::ComputeV1::ComputeService).to receive(:insert_instance).with(project_name, valid_attributes[:region], instance_of(::Google::Apis::ComputeV1::Instance)).and_return(double(target_link: 'instance_id'))
    end

    it_behaves_like 'deployment controller'

    describe 'GET #new' do
      context 'with Google OAuth credentials' do
        before { expect_any_instance_of(Google::Auth::WebUserAuthorizer).to receive(:get_credentials).with(user.to_param, request).and_return(foo: :bar) }
        it 'sets the deployment credentials' do
          get :new, { template_id: template.id }, valid_session
          expect(assigns(:deployment).google_auth).not_to be_nil
        end
      end

      context 'without Google OAuth credentials' do
        before { expect_any_instance_of(Google::Auth::WebUserAuthorizer).to receive(:get_credentials).with(user.to_param, request).and_raise(StandardError) }
        it 'does not set the deployment credentials' do
          get :new, { template_id: template.id }, valid_session
          expect(assigns(:deployment).google_auth).to be_nil
        end
      end
    end

    describe 'POST #options' do
      context 'with generic provider validation failure' do
        before { allow_any_instance_of(Google::Apis::ComputeV1::ComputeService).to receive(:list_zones).and_raise(StandardError) }
        it_behaves_like 'deployment with invalid options'
      end
    end
  end
end
