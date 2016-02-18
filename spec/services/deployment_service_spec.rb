require 'rails_helper'

RSpec.describe DeploymentService, type: :service do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployment) { stub_model(Deployment, template: template, provider_type: 'aws', credentials: {}) }
  subject { DeploymentService.new(deployment) }

  describe 'delegates' do
    it { is_expected.to delegate_method(:regions).to(:provider) }
    it { is_expected.to delegate_method(:flavors).to(:provider) }
    it { is_expected.to delegate_method(:valid?).to(:provider) }
  end

  describe 'images' do
    let(:images) { [double(image_id: 'image-id', name: 'Image')] }
    before { allow_any_instance_of(Aws::EC2::Client).to receive(:describe_images).and_return(double(images: images)) }
    it { expect(subject.images).to match_array images }
  end
end
