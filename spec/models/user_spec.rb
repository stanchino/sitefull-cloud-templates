require 'rails_helper'
require 'cancan/matchers'

describe User, type: :model do
  describe 'validation' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:email) }
    context 'email is unique' do
      subject { FactoryGirl.create(:user) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe 'relations' do
    it { is_expected.to have_many(:templates) }
    it { is_expected.to have_many(:accesses).dependent(:destroy) }
    it { is_expected.to have_many(:deployments) }
    it { is_expected.to have_many(:providers).through(:accesses) }
  end

  describe 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    subject(:ability) { Ability.new(user) }
    it { is_expected.to be_able_to(:manage, user) }
    it { is_expected.not_to be_able_to(:manage, User.new) }
  end
end
