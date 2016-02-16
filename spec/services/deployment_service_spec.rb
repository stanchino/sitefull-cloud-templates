require 'rails_helper'

RSpec.describe DeploymentService, type: :service do
  let(:deployment) { FactoryGirl.create(:deployment) }
  subject { DeploymentService.new(deployment) }

  describe 'delegates' do
    it { is_expected.to delegate_method(:provider_type).to(:deployment) }
    it { is_expected.to delegate_method(:credentials).to(:deployment) }
    it { is_expected.to delegate_method(:image).to(:deployment) }
    it { is_expected.to delegate_method(:flavor).to(:deployment) }
    it { is_expected.to delegate_method(:regions).to(:provider) }
    it { is_expected.to delegate_method(:flavors).to(:provider) }
    it { is_expected.to delegate_method(:valid?).to(:provider) }
    it { is_expected.to delegate_method(:create_network).to(:provider) }
  end

  describe 'images' do
    it { expect(subject.images).to match_array Providers::Aws::IMAGES[:debian] }
  end
end
