require 'rails_helper'

RSpec.describe DeploymentJob, type: :job do
  describe 'perform' do
    let(:deployment) { FactoryGirl.create(:deployment) }
    Sidekiq::Testing.inline! do
      it { expect(subject.perform(deployment)).to be_truthy }
    end
  end
end
