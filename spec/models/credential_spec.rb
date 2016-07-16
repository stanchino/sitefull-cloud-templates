# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Credential, type: :model do
  it { is_expected.to belong_to(:provider) }
  it { is_expected.to belong_to(:account) }
end
