require 'rails_helper'

RSpec.describe Deployment, type: :model do
  subject { FactoryGirl.build(:deployment) }
  before { FactoryGirl.create(:credential, subject.provider_textkey.to_sym, provider_id: subject.provider_id, account_id: subject.accounts_user.account_id) }
  describe 'relationships' do
    it { is_expected.to belong_to(:template) }
    it { is_expected.to belong_to(:accounts_user) }
    it { is_expected.to belong_to(:provider) }
    it { is_expected.to have_one(:account).through(:accounts_user) }
    it { is_expected.to have_one(:user).through(:accounts_user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:accounts_user) }
    it { is_expected.to validate_presence_of(:region) }
    it { is_expected.to validate_presence_of(:image) }
    it { is_expected.to validate_presence_of(:machine_type) }
  end

  describe 'delegates' do
    it { is_expected.to delegate_method(:os).to(:template) }
    it { is_expected.to delegate_method(:script).to(:template) }
  end
end
