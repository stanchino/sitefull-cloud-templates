require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'relations' do
    it { is_expected.to have_many(:providers) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
