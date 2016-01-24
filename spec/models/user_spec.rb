require 'rails_helper'
require 'cancan/matchers'

describe User, type: :model do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { FactoryGirl.create(:user) }
    it { is_expected.to be_able_to(:manage, user) }
    it { is_expected.not_to be_able_to(:manage, User.new) }
  end
end
