require 'rails_helper'

RSpec.describe DeploymentService, type: :service do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployment) { stub_model(Deployment, template: template, provider_type: 'amazon', token: '{"access_key": "access_key"}', role_arn: 'role') }
  subject { DeploymentService.new(deployment) }

  describe 'delegates' do
    it { is_expected.to delegate_method(:regions).to(:provider) }
    it { is_expected.to delegate_method(:machine_types).to(:provider) }
    it { is_expected.to delegate_method(:valid?).to(:provider) }
  end

  describe 'images' do
    it { expect(subject.images).to match_array Sitefull::Cloud::Provider.new(:amazon).images(deployment.os) }
  end
end
