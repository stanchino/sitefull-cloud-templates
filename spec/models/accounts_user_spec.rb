require 'rails_helper'

RSpec.describe AccountsUser, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to :account }
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:deployments).dependent(:destroy) }
  end
end
