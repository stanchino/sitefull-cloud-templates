require 'rails_helper'

RSpec.describe 'deployments/show', type: :view do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployment) { stub_model(Deployment, template: template, image: 'image', key_name: 'key_name', instance_id: 'instance_id') }
  let(:decorator) { DeploymentDecorator.new(deployment) }
  before do
    assign(:deployment, deployment)
    assign(:decorator, decorator)
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(/#{deployment.provider_type}/)
    expect(rendered).to match(/#{deployment.region}/)
    expect(rendered).to match(/#{deployment.machine_type}/)
    expect(rendered).to match(/#{deployment.image}/)
    expect(rendered).to match(/#{decorator.public_ip}/)
  end
end
