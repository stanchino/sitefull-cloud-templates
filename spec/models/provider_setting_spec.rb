require 'rails_helper'

RSpec.describe ProviderSetting, type: :model do
  it { is_expected.to belong_to(:provider) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:provider_id) }
end
