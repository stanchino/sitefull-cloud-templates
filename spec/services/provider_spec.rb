require 'rails_helper'

RSpec.describe Provider, type: :service do
  let(:type) { 'aws' }
  let(:options) { { foo: :bar } }
  subject { Provider.new(type, options) }

  describe 'regions' do
    it { expect(subject.regions).not_to be_empty }
  end

  describe 'flavors' do
    it { expect(subject.flavors).not_to be_empty }
  end

  describe 'type' do
    it { expect(subject.type).to eq type }
  end
end
