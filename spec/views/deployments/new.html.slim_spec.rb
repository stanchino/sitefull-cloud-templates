require 'rails_helper'

RSpec.describe 'deployments/new', type: :view do
  let(:deployment) { FactoryGirl.build(:deployment) }
  let(:providers) { deployment.user.organization.providers }
  before do
    assign(:template, deployment.template)
    assign(:deployment, deployment)
    assign(:decorator, DeploymentDecorator.new(deployment))
    assign(:providers, providers)
  end

  it 'renders new deployment form' do
    render

    assert_select 'form[action=?][method=?]', template_deployments_path(deployment.template), 'post' do
      providers.each do |provider|
        assert_select "input#deployment_provider_id_#{provider.id}[name=?]", 'deployment[provider_id]'
      end

      %w(region machine_type).each do |type|
        assert_select "select#deployment_#{type}[name=?]", "deployment[#{type}]"
      end
    end
  end
end
