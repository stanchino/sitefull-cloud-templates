require 'rails_helper'

RSpec.describe Provider::Factory do
  subject { Provider::Factory.new(type, options) }
  describe 'with type set to Amazon' do
    let(:type) { 'amazon' }
    let(:options) { { token: '{"access_key": "access_key"}', role_arn: 'role', foo: :bar } }

    describe 'regions' do
      it { expect(subject.regions).not_to be_empty }
    end

    describe 'flavors' do
      it { expect(subject.flavors).not_to be_empty }
    end

    describe 'images' do
      it { expect(subject.images('debian')).not_to be_empty }
    end

    describe 'valid?' do
      it { expect(subject.valid?).to be_truthy }
    end

    describe 'type' do
      it { expect(subject.instance_variable_get(:@type)).to eq type }
    end
  end

  describe 'without type' do
    let(:type) { nil }
    let(:options) { nil }
    [:regions, :flavors].each do |method|
      context "returns an empty array for #{method}" do
        it { expect(subject.send(method)).to eq [] }
      end
    end
    context 'returns an empty array for images' do
      it { expect(subject.images(any_args)).to eq [] }
    end
  end
end
