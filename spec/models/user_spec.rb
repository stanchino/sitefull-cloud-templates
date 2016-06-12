require 'rails_helper'
require 'cancan/matchers'

describe User, type: :model do
  describe 'validation' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }

    context 'email is unique' do
      subject { FactoryGirl.create(:user) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe 'relations' do
    it { is_expected.to have_many(:templates) }
    it { is_expected.to have_many(:accounts_users).dependent(:destroy) }
    it { is_expected.to have_many(:accounts).through(:accounts_users) }
    it { is_expected.to have_many(:deployments).through(:accounts_users) }
  end

  describe 'delegates' do
    it { is_expected.to delegate_method(:organization).to(:current_account) }
  end

  describe 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    subject(:ability) { Ability.new(user) }
    it { is_expected.to be_able_to(:manage, user) }
    it { is_expected.not_to be_able_to(:manage, User.new) }
  end

  describe 'after create' do
    subject { FactoryGirl.create(:user) }
    it 'the current account is created' do
      expect(subject.current_account).to be_present
      expect(subject.current_account.name).to eq subject.email
    end

    it 'the accounts user record is created' do
      expect(subject.current_account).not_to be_nil
      expect(subject.accounts).not_to be_empty
      expect(subject.accounts).to match_array [subject.current_account]
    end
  end
end
