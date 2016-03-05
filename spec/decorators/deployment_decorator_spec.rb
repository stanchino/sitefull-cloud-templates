require 'rails_helper'

RSpec.describe DeploymentDecorator, type: :decorator do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployment) { stub_model(Deployment, template: template) }
  subject { DeploymentDecorator.new(deployment) }
  describe 'methods' do
    [:regions, :machine_types, :images, :regions_for_select, :machine_types_for_select, :images_for_select].each do |method|
      context "returns an empty array for #{method}" do
        it { expect(subject.send(method)).not_to be_empty }
      end
    end
  end
end
