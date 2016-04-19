require 'rails_helper'

RSpec.shared_examples 'page with progress states' do |state_messages, state_css|
  state_messages.each do |state|
    it { expect(rendered).to match(/#{I18n.t("deployment_states.#{state}")}/) }
  end
  state_css.each do |state|
    it { assert_select "pre##{state}" }
  end
end

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
    let(:failed_state) { nil }
    let(:deployment) { stub_model(Deployment, template: template, state: state, failed_state: failed_state, image: 'image', key_name: 'key_name', instance_id: 'instance_id') }
    before { render }

    context 'for completed deployment' do
      let(:state) { :completed }
      it_behaves_like 'page with progress states',
                      %w(creating_network.after creating_firewall_rules.after creating_access_key.after creating_instance.after starting_instance.after executing_script.after),
                      %w(network_setup.completed firewall_setup.completed access_setup.completed instance_setup.completed instance_state.completed script_execution.completed)
    end

    context 'for running deployment' do
      let(:state) { :creating_instance }
      it_behaves_like 'page with progress states',
                      %w(creating_network.after creating_firewall_rules.after creating_access_key.after creating_instance.before starting_instance.before executing_script.before),
                      %w(network_setup.completed firewall_setup.completed access_setup.completed instance_setup.running instance_state.hidden script_execution.hidden)
    end

    context 'for failed deployment' do
      let(:state) { :failed }
      let(:failed_state) { :creating_instance }
      it_behaves_like 'page with progress states',
                      %w(creating_network.after creating_firewall_rules.after creating_access_key.after creating_instance.failed starting_instance.before executing_script.before),
                      %w(network_setup.completed firewall_setup.completed access_setup.completed instance_setup.failed instance_state.hidden script_execution.hidden)
    end
  end
end
