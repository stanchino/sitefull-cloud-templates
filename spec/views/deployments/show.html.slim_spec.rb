# frozen_string_literal: true
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
  let(:deployment) { FactoryGirl.create(:deployment, image: 'image-id-1', key_name: 'key_name', instance_id: 'instance_id') }
  let(:decorator) { DeploymentDecorator.new(deployment) }
  before do
    assign(:deployment, deployment)
    assign(:decorator, decorator)
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(/#{I18n.t("providers.#{deployment.provider_textkey}")}/)
    expect(rendered).to match(/#{deployment.region}/)
    expect(rendered).to match(/#{deployment.machine_type}/)
    expect(rendered).to match(/#{deployment.image}/)
    expect(rendered).to match(/#{decorator.public_ip}/)
  end

  describe 'deployment progress' do
    let(:failed_state) { nil }
    let(:deployment) { FactoryGirl.create(:deployment, state: state, failed_state: failed_state, image: 'image-id-1', key_name: 'key_name', instance_id: 'instance_id') }
    before { render }

    [
      [:completed, nil, [:after, :after, :after, :after, :after, :after], [:completed, :completed, :completed, :completed, :completed, :completed]],
      [:creating_access_key, nil, [:after, :after, :before, :before, :before, :before], [:completed, :completed, :running, :hidden, :hidden, :hidden]],
      [:failed, :creating_instance, [:after, :after, :after, :failed, :before, :before], [:completed, :completed, :completed, :failed, :hidden, :hidden]]
    ].each do |state, failed_state, messages, blocks|
      context "for #{state} deployment" do
        let(:state) { state }
        let(:failed_state) { failed_state }
        it_behaves_like 'page with progress state messages', messages
        it_behaves_like 'page with progress state blocks', blocks
      end
    end
  end
end
