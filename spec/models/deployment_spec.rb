require 'rails_helper'

RSpec.describe Deployment, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:template) }
    it { is_expected.to belong_to(:deployment_credential) }
    it { is_expected.to have_one(:credential).through(:deployment_credential).inverse_of(:deployments) }
    it { is_expected.to have_one(:aws_credential).through(:deployment_credential).inverse_of(:deployments) }
    it { is_expected.to accept_nested_attributes_for(:deployment_credential) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:image) }
    it { is_expected.to validate_presence_of(:flavor) }
  end

  describe 'delegated methods' do
    it { is_expected.to delegate_method(:user_id).to(:template) }
  end
end
