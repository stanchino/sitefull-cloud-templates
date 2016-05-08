require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to :organization }
    it { is_expected.to have_many(:accounts_users).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:accounts_users) }
    it { is_expected.to have_many(:accesses).dependent(:destroy) }
    it { is_expected.to have_many(:providers).through(:accesses) }
  end
end
