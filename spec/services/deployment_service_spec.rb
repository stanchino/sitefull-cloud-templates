require 'rails_helper'

RSpec.describe DeploymentService, type: :service do
=begin
  let(:template) { FactoryGirl.create(:template, os: 'debian') }
  let(:deployment) { FactoryGirl.create(:deployment, template: template, provider_type: 'amazon', role_arn: 'role', session_name: 'session_id') }
  subject { DeploymentService.new(deployment) }

  describe 'delegates' do
    it { is_expected.to delegate_method(:regions).to(:provider) }
    it { is_expected.to delegate_method(:machine_types).to(:provider) }
    it { is_expected.to delegate_method(:valid?).to(:provider) }
  end

  describe 'images' do
    it { expect(subject.images).to match_array Sitefull::Cloud::Provider.new(:amazon).images(deployment.os) }
  end

  describe 'ssh_user' do
    Template::OPERATING_SYSTEMS.each do |os, _|
      context "for #{os}" do
        let(:template) { FactoryGirl.create(:template, os: os) }
        it { expect(subject.send(:ssh_user)).not_to be_empty }
        it { expect(subject.send(:ssh_user)).not_to eq 'sitefull' }
      end
    end
  end
=end
end
