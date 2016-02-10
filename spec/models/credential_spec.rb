require 'rails_helper'

RSpec.describe Credential, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:deployment_credentials) }
    it { is_expected.to have_many(:deployments).through(:deployment_credentials).inverse_of(:credential) }
  end
end
