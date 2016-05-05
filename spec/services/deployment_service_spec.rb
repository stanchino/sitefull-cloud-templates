require 'rails_helper'

RSpec.describe DeploymentService, type: :service do
  let(:template) { FactoryGirl.create(:template, os: 'debian') }
  let(:deployment) { FactoryGirl.create(:deployment, template: template, user: template.user, provider_type: 'amazon', role_arn: 'role', session_name: 'session_id') }
  subject { DeploymentService.new(deployment) }

  describe 'ssh_user' do
    Template::OPERATING_SYSTEMS.each do |os, _|
      context "for #{os}" do
        let(:template) { FactoryGirl.create(:template, os: os) }
        it { expect(subject.send(:ssh_user)).not_to be_empty }
        it { expect(subject.send(:ssh_user)).not_to eq 'sitefull' }
      end
    end
  end
end
