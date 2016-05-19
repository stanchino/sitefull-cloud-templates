require 'rails_helper'

RSpec.describe Provider, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:deployments).dependent(:destroy) }
    it { is_expected.to have_many(:credentials).dependent(:destroy) }
    it { is_expected.to have_many(:settings).class_name('ProviderSetting').dependent(:destroy) }
    it { is_expected.to have_many(:accounts).through(:credentials) }
    it { is_expected.to accept_nested_attributes_for(:settings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:textkey) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:organization_id) }
    it { is_expected.to validate_uniqueness_of(:textkey).scoped_to(:organization_id) }
    Sitefull::Cloud::Provider::PROVIDERS.each do |textkey|
      context "when textkey #{textkey} is included in the list" do
        subject { Provider.where(textkey: textkey).first_or_initialize }
        it { is_expected.to be_valid }
      end
    end
    context 'when textkey is not included in the list' do
      subject { stub_model(Provider, name: 'Provider', textkey: 'Other') }
      it { is_expected.not_to be_valid }
    end
  end
end
