require 'rails_helper'

RSpec.describe 'deployments/show', type: :view do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployment) { stub_model(Deployment, template: template, image: 'image', key_name: 'key_name', instance_id: 'instance_id') }
  before { assign(:deployment, deployment) }

  it 'renders attributes' do
    render
    expect(rendered).to match(/#{deployment.provider_type}/)
    expect(rendered).to match(/#{deployment.region}/)
    expect(rendered).to match(/#{deployment.machine_type}/)
    expect(rendered).to match(/#{deployment.image}/)
  end
end
