require 'rails_helper'

RSpec.describe DeploymentService, type: :service do
  let(:deployment) { FactoryGirl.create(:deployment, :amazon, template: template) }
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
