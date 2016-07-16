# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TemplatesHelper, type: :helper do
  describe 'validators_collection' do
    it { expect(helper.validators_collection).not_to be_empty }
    it { expect(helper.validators_collection.keys).to match_array DeploymentArgumentsValidator::VALIDATORS.keys.map { |key| I18n.t("validators.collection_names.#{key}") } }
    it { expect(helper.validators_collection.values).to match_array DeploymentArgumentsValidator::VALIDATORS.keys }
  end
end
