require 'rails_helper'

RSpec.shared_examples 'page with progress state messages' do |states|
  it { expect(rendered).to match(/#{I18n.t("deployment_states.creating_network.#{states[:creating_network]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.creating_firewall_rules.#{states[:creating_firewall_rules]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.creating_access_key.#{states[:creating_access_key]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.creating_instance.#{states[:creating_instance]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.starting_instance.#{states[:starting_instance]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.executing_script.#{states[:executing_script]}")}/) }
end

RSpec.shared_examples 'page with progress state blocks' do |states|
  it { assert_select "pre#network_setup.#{states[:creating_network]}" }
  it { assert_select "pre#firewall_setup.#{states[:creating_firewall_rules]}" }
  it { assert_select "pre#access_setup.#{states[:creating_access_key]}" }
  it { assert_select "pre#instance_setup.#{states[:creating_instance]}" }
  it { assert_select "pre#instance_state.#{states[:starting_instance]}" }
  it { assert_select "pre#script_execution.#{states[:executing_script]}" }
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
      it_behaves_like 'page with progress state messages', creating_network: :after, creating_firewall_rules: :after, creating_access_key: :after, creating_instance: :after, starting_instance: :after, executing_script: :after
      it_behaves_like 'page with progress state blocks', creating_network: :completed, creating_firewall_rules: :completed, creating_access_key: :completed, creating_instance: :completed, starting_instance: :completed, executing_script: :completed
    end

    context 'for running deployment' do
      let(:state) { :creating_instance }
      it_behaves_like 'page with progress state messages', creating_network: :after, creating_firewall_rules: :after, creating_access_key: :after, creating_instance: :before, starting_instance: :before, executing_script: :before
      it_behaves_like 'page with progress state blocks', creating_network: :completed, creating_firewall_rules: :completed, creating_access_key: :completed, creating_instance: :running, starting_instance: :hidden, executing_script: :hidden
    end

    context 'for failed deployment' do
      let(:state) { :failed }
      let(:failed_state) { :creating_instance }
      it_behaves_like 'page with progress state messages', creating_network: :after, creating_firewall_rules: :after, creating_access_key: :after, creating_instance: :failed, starting_instance: :before, executing_script: :before
      it_behaves_like 'page with progress state blocks', creating_network: :completed, creating_firewall_rules: :completed, creating_access_key: :completed, creating_instance: :failed, starting_instance: :hidden, executing_script: :hidden
    end
  end
end
