require 'rails_helper'

RSpec.describe Deployment, type: :model do
  before { subject.template = FactoryGirl.create(:template) }
  describe 'relationships' do
    it { is_expected.to belong_to(:template) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider_type) }
    it { is_expected.to validate_presence_of(:region) }
    it { is_expected.to validate_presence_of(:image) }
    it { is_expected.to validate_presence_of(:flavor) }
  end

  describe 'delegates' do
    it { is_expected.to delegate_method(:regions).to(:decorator) }
    it { is_expected.to delegate_method(:flavors).to(:decorator) }
    it { is_expected.to delegate_method(:images).to(:decorator) }
    it { is_expected.to delegate_method(:os).to(:template) }
  end
end
