require 'rails_helper'

RSpec.describe 'deployments/show', type: :view do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployment) { stub_model(Deployment, template: template, image: 'image', key_name: 'key_name', instance_id: 'instance_id') }
  let(:decorator) { DeploymentDecorator.new(deployment) }
  before do
    assign(:deployment, deployment)
    assign(:decorator, decorator)
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(/#{deployment.provider_type}/)
    expect(rendered).to match(/#{deployment.region}/)
    expect(rendered).to match(/#{deployment.machine_type}/)
    expect(rendered).to match(/#{deployment.image}/)
    expect(rendered).to match(/#{decorator.public_ip}/)
  end

  describe 'deployment progress' do
    before { render }
    context 'for completed deployment' do
      let(:deployment) { stub_model(Deployment, template: template, state: :completed, image: 'image', key_name: 'key_name', instance_id: 'instance_id') }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_network.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_firewall_rules.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_access_key.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_instance.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.starting_instance.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.executing_script.after')}/) }
      it { assert_select 'pre#network_setup.completed' }
      it { assert_select 'pre#firewall_setup.completed' }
      it { assert_select 'pre#access_setup.completed' }
      it { assert_select 'pre#instance_setup.completed' }
      it { assert_select 'pre#instance_state.completed' }
      it { assert_select 'pre#script_execution.completed' }
    end

    context 'for running deployment' do
      let(:deployment) { stub_model(Deployment, template: template, state: :creating_instance, image: 'image', key_name: 'key_name', instance_id: 'instance_id') }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_network.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_firewall_rules.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_access_key.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_instance.before')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.starting_instance.before')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.executing_script.before')}/) }
      it { assert_select 'pre#network_setup.completed' }
      it { assert_select 'pre#firewall_setup.completed' }
      it { assert_select 'pre#access_setup.completed' }
      it { assert_select 'pre#instance_setup.running' }
      it { assert_select 'pre#instance_state.hidden' }
      it { assert_select 'pre#script_execution.hidden' }
    end
    context 'for failed deployment' do
      let(:deployment) { stub_model(Deployment, template: template, state: :failed, failed_state: :creating_instance, image: 'image', key_name: 'key_name', instance_id: 'instance_id') }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_network.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_firewall_rules.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_access_key.after')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.creating_instance.failed')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.starting_instance.before')}/) }
      it { expect(rendered).to match(/#{I18n.t('deployment_states.executing_script.before')}/) }
      it { assert_select 'pre#network_setup.completed' }
      it { assert_select 'pre#firewall_setup.completed' }
      it { assert_select 'pre#access_setup.completed' }
      it { assert_select 'pre#instance_setup.failed' }
      it { assert_select 'pre#instance_state.hidden' }
      it { assert_select 'pre#script_execution.hidden' }
    end
  end
end
