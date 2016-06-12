require 'rails_helper'

RSpec.describe TemplateArgument, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:textkey) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:validator) }
    it { is_expected.to validate_uniqueness_of(:textkey).scoped_to(:template_id) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:template_id) }
    it { is_expected.to validate_inclusion_of(:validator).in_array(DeploymentArgumentsValidator::VALIDATORS.keys.map(&:to_s)) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:template) }
  end
end
