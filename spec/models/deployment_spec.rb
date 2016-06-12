require 'rails_helper'

RSpec.describe Deployment, type: :model do
  subject { FactoryGirl.build(:deployment) }
  before { FactoryGirl.create(:credential, subject.provider_textkey.to_sym, provider_id: subject.provider_id, account_id: subject.accounts_user.account_id) }
  describe 'relationships' do
    it { is_expected.to belong_to(:template) }
    it { is_expected.to belong_to(:accounts_user) }
    it { is_expected.to belong_to(:provider) }
    it { is_expected.to have_one(:account).through(:accounts_user) }
    it { is_expected.to have_one(:user).through(:accounts_user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:accounts_user) }
    it { is_expected.to validate_presence_of(:region) }
    it { is_expected.to validate_presence_of(:image) }
    it { is_expected.to validate_presence_of(:machine_type) }

    context 'for arguments' do
      let!(:template_argument) { FactoryGirl.create(:template_argument, options.merge(template: subject.template)) }
      before { subject.arguments = { template_argument.textkey.to_s => value } }

      context 'with invalid values' do
        before { subject.valid? }

        context 'when required value is missing' do
          let(:options) { { required: true } }
          let(:value) { '' }
          it { is_expected.to be_invalid }
          it { expect(subject.errors['arguments']).not_to be_blank }
          it { expect(subject.errors['arguments'].select { |e| e.keys.include? template_argument.textkey }.map(&:values).flatten).to include "can't be blank" }
        end

        context 'when required value is present but invalid' do
          let(:options) { { required: true, validator: :domain } }
          let(:value) { 'invalid domain' }
          it { is_expected.to be_invalid }
          it { expect(subject.errors['arguments']).not_to be_blank }
          it { expect(subject.errors['arguments'].select { |e| e.keys.include? template_argument.textkey }.map(&:values).flatten).to match_array ['is invalid'] }
        end

        context 'when non-required value is present but invalid' do
          let(:options) { { required: false, validator: :domain } }
          let(:value) { 'invalid domain' }
          it { is_expected.to be_invalid }
          it { expect(subject.errors['arguments']).not_to be_blank }
          it { expect(subject.errors['arguments'].select { |e| e.keys.include? template_argument.textkey }.map(&:values).flatten).to match_array ['is invalid'] }
        end
      end

      context 'with valid arguments' do
        before { subject.valid? }

        context 'when required value is present and valid' do
          let(:options) { { required: true, validator: :domain } }
          let(:value) { 'example.com' }
          it { is_expected.to be_valid }
          it { expect(subject.errors['arguments']).to be_blank }
        end

        context 'when non-required value is missing' do
          let(:options) { { required: false, validator: :domain } }
          let(:value) { '' }
          it { is_expected.to be_valid }
          it { expect(subject.errors['arguments']).to be_blank }
        end
      end
    end
  end

  describe 'delegates' do
    it { is_expected.to delegate_method(:os).to(:template) }
    it { is_expected.to delegate_method(:script).to(:template) }
  end
end
