require 'rails_helper'

RSpec.describe DeploymentService, type: :service do
  let(:template) { FactoryGirl.create(:template, os: 'debian') }
  let(:accounts_user) { AccountsUser.where(user: template.user, account: template.user.current_account).first }
  let(:deployment) { FactoryGirl.create(:deployment, template: template, accounts_user: accounts_user, provider_type: 'amazon', role_arn: 'role', session_name: 'session_id') }
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
