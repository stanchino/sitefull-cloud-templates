require 'rails_helper'

RSpec.describe AwsCredential, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:aws_access_key_id) }
    it { is_expected.to validate_presence_of(:aws_secret_access_key) }
  end
end
