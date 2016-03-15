require 'rails_helper'

RSpec.describe Provider, type: :model do
  it { is_expected.to have_many(:accesses).dependent(:destroy) }
  it { is_expected.to have_many(:settings).class_name('ProviderSetting').dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:accesses) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:textkey) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_uniqueness_of(:textkey) }
end
