require 'rails_helper'

RSpec.describe Access, type: :model do
  it { is_expected.to belong_to(:provider) }
  it { is_expected.to belong_to(:user) }
end
