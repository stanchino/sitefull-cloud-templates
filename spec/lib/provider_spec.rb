require 'rails_helper'

RSpec.describe Provider do
  let(:type) { 'aws' }
  let(:options) { { foo: :bar } }
  subject { Provider.new(type, options) }

  describe 'regions' do
    it { expect(subject.regions).not_to be_empty }
  end

  describe 'flavors' do
    it { expect(subject.flavors).not_to be_empty }
  end

  describe 'valid?' do
    it { expect(subject.valid?).to be_truthy }
  end

  describe 'type' do
    it { expect(subject.instance_variable_get(:@type)).to eq type }
  end
end
