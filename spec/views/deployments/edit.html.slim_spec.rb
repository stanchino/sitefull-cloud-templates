require 'rails_helper'

RSpec.describe 'deployments/edit', type: :view do
  let(:providers) { deployment.user.organization.providers }
  before do
    FactoryGirl.create(:provider, :amazon, organization: deployment.user.organization)
    FactoryGirl.create(:provider, :azure, organization: deployment.user.organization)
    FactoryGirl.create(:provider, :google, organization: deployment.user.organization)
    assign(:template, deployment.template)
    assign(:deployment, deployment)
    assign(:decorator, DeploymentDecorator.new(deployment))
    assign(:providers, providers)
  end

  Sitefull::Cloud::Provider::PROVIDERS.each do |provider_type|
    let(:deployment) { FactoryGirl.create(:deployment, provider_type.to_sym) }
    it 'renders new deployment form' do
      render

      assert_select 'form[action=?][method=?]', template_deployment_path(deployment.template, deployment), 'post' do
        providers do |provider|
          if provider.textkey == provider_type
            assert_select "input#deployment_provider_id_#{provider.id}[name=?][checked=checked]", 'deployment[provider_id]'
          else
            assert_select "input#deployment_provider_id_#{provider.id}[name=?]", 'deployment[provider_id]'
          end
        end

        %w(region machine_type).each do |type|
          assert_select "select#deployment_#{type}[name=?]", "deployment[#{type}]"
        end
      end
    end
  end
end
