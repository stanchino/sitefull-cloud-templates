require 'rails_helper'

RSpec.describe 'deployments/show', type: :view do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployment) { stub_model(Deployment, provider_type: 'aws', template: template, image: 'image', key_name: 'key_name', instance_id: 'instance_id') }
  before { assign(:deployment, deployment) }

  it 'renders attributes' do
    render
    expect(rendered).to match(/#{I18n.t("providers.#{deployment.provider_type}")}/)
    expect(rendered).to match(/#{deployment.region}/)
    expect(rendered).to match(/#{deployment.flavor}/)
    expect(rendered).to match(/#{deployment.image}/)
    expect(rendered).to match(/#{deployment.key_name}/)
    expect(rendered).to match(/#{deployment.instance_id}/)
    assert_select 'a[href=?]', template_deployments_url(template), text: 'Back'
  end
end
