require 'rails_helper'

RSpec.shared_examples 'page with progress state messages' do |states|
  it { expect(rendered).to match(/#{I18n.t("deployment_states.creating_network.#{states[0]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.creating_firewall_rules.#{states[1]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.creating_access_key.#{states[2]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.creating_instance.#{states[3]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.starting_instance.#{states[4]}")}/) }
  it { expect(rendered).to match(/#{I18n.t("deployment_states.executing_script.#{states[5]}")}/) }
end

RSpec.shared_examples 'page with progress state blocks' do |states|
  it { assert_select "pre#network_setup.#{states[0]}" }
  it { assert_select "pre#firewall_setup.#{states[1]}" }
  it { assert_select "pre#access_setup.#{states[2]}" }
  it { assert_select "pre#instance_setup.#{states[3]}" }
  it { assert_select "pre#instance_state.#{states[4]}" }
  it { assert_select "pre#script_execution.#{states[5]}" }
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
      it_behaves_like 'page with progress state messages', [:after, :after, :after, :after, :after, :after]
      it_behaves_like 'page with progress state blocks', [:completed, :completed, :completed, :completed, :completed, :completed]
    end

    context 'for running deployment' do
      let(:state) { :creating_instance }
      it_behaves_like 'page with progress state messages', [:after, :after, :after, :before, :before, :before]
      it_behaves_like 'page with progress state blocks', [:completed, :completed, :completed, :running, :hidden, :hidden]
    end

    context 'for failed deployment' do
      let(:state) { :failed }
      let(:failed_state) { :creating_instance }
      it_behaves_like 'page with progress state messages', [:after, :after, :after, :failed, :before, :before]
      it_behaves_like 'page with progress state blocks', [:completed, :completed, :completed, :failed, :hidden, :hidden]
    end
  end
end
