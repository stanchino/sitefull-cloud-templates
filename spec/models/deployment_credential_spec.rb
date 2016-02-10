require 'rails_helper'

RSpec.describe DeploymentCredential, type: :model do
  describe 'relationshipts' do
    it { is_expected.to have_one(:deployment) }
    it { is_expected.to belong_to(:aws_credential) }
    it { is_expected.to accept_nested_attributes_for(:aws_credential) }
  end
end
