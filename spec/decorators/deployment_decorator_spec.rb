# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DeploymentDecorator, type: :decorator do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployment) { stub_model(Deployment, template: template) }
  subject { DeploymentDecorator.new(deployment) }
  describe 'methods' do
    [:regions, :machine_types, :images, :regions_for_select, :machine_types_for_select, :images_for_select, :provider_regions, :provider_images, :provider_machine_types].each do |method|
      context "returns an empty array for #{method}" do
        it { expect(subject.send(method)).to match_array [] }
      end
    end

    context 'returns nil for instance_data' do
      it { expect(subject.send(:instance_data)).to be_nil }
    end

    describe '#valid?' do
      let(:provider) { stub_model(Provider) }
      let(:deployment) { stub_model(Deployment, template: template, provider: provider) }
      context 'for invalid provider' do
        before { expect_any_instance_of(ProviderDecorator).to receive_message_chain(:provider, :valid?).and_raise(StandardError) }
        it 'returns false' do
          expect(subject.valid?).to be_falsey
        end
      end
    end
  end
end
