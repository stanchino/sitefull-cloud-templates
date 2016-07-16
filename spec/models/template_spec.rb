# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:os) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:deployments) }
    it { is_expected.to have_many(:arguments) }
  end
end
