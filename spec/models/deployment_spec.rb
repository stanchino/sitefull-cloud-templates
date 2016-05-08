require 'rails_helper'

RSpec.describe Deployment, type: :model do
  before { subject.template = stub_model(Template) }
  describe 'relationships' do
    it { is_expected.to belong_to(:template) }
    it { is_expected.to belong_to(:accounts_user) }
    it { is_expected.to have_one(:account).through(:accounts_user) }
    it { is_expected.to have_one(:user).through(:accounts_user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider_type) }
    it { is_expected.to validate_presence_of(:region) }
    it { is_expected.to validate_presence_of(:image) }
    it { is_expected.to validate_presence_of(:machine_type) }
  end

  describe 'delegates' do
    it { is_expected.to delegate_method(:os).to(:template) }
    it { is_expected.to delegate_method(:script).to(:template) }
  end
end
