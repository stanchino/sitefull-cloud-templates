# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DeploymentArgument, type: :model do
  let(:deployment) { stub_model(Deployment) }
  let(:argument) { stub_model(TemplateArgument, textkey: :textkey) }
  subject { DeploymentArgument.new(deployment, argument) }

  it { is_expected.to respond_to(:textkey) }
  it { is_expected.not_to respond_to(:errors) }

  context 'with errors' do
    let(:deployment) { stub_model(Deployment, errors: { arguments: [{ 'textkey' => :error_one }, { 'textkey' => :error_two }, { 'other_textkey' => :other }] }) }
    it { is_expected.to respond_to(:errors) }
    it { expect(subject.errors).not_to be_nil }
    it { expect(subject.errors['textkey']).to match_array [:error_one, :error_two] }
  end
end
