require 'rails_helper'

describe User, type: :model do
  describe 'validation' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:email) }
    describe 'email should be unique' do
      subject { FactoryGirl.create(:user) }
      before { allow(subject).to receive(:confirm).and_return(true) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { FactoryGirl.create(:user) }
    it { is_expected.to be_able_to(:manage, user) }
    it { is_expected.not_to be_able_to(:manage, User.new) }
  end
end
