require 'rails_helper'

RSpec.describe DeploymentJob, type: :job do
  describe 'perform' do
    let(:deployment) { FactoryGirl.create(:deployment) }
    before do
      allow_any_instance_of(Aws::EC2::Client).to receive(:run_instances).and_return(double(instances: [double(instance_id: 'instance_id')]))
    end
    Sidekiq::Testing.inline! do
      it { expect(subject.perform(deployment.id)).to be_truthy }
    end
  end
end
