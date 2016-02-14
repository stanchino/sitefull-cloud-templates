require 'rails_helper'

RSpec.describe DeploymentDecorator, type: :decorator do
  let(:deployment) { stub_model(Deployment) }
  subject { DeploymentDecorator.new(deployment) }
  describe 'methods' do
    [:regions, :flavors, :images, :regions_for_select, :flavors_for_select, :images_for_select].each do |method|
      context "returns an empty array for #{method}" do
        it { expect(subject.send(method)).to eq [] }
      end
    end
  end
end
