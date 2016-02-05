require 'rails_helper'

RSpec.describe Deployment, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:template) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:image) }
    it { is_expected.to validate_presence_of(:flavor) }
  end
end
