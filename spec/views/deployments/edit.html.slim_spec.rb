require 'rails_helper'

RSpec.describe 'deployments/edit', type: :view do
  let(:template) { stub_model(Template, os: 'debian') }
  before do
    assign(:template, template)
    assign(:deployment, deployment)
    assign(:decorator, DeploymentDecorator.new(deployment))
    assign(:provider_types, Sitefull::Cloud::Provider::PROVIDERS)
  end

  # Deployment::PROVIDERS.each do |provider_type|
  [:amazon, :google].each do |provider_type|
    let(:deployment) { stub_model(Deployment, template: template) }
    it 'renders new deployment form' do
      render

      assert_select 'form[action=?][method=?]', template_deployment_path(template, deployment), 'post' do
        Sitefull::Cloud::Provider::PROVIDERS.each do |provider|
          if provider == provider_type
            assert_select "input#deployment_provider_type_#{provider}[name=?][checked=checked]", 'deployment[provider_type]'
          else
            assert_select "input#deployment_provider_type_#{provider}[name=?]", 'deployment[provider_type]'
          end
        end

        %w(region machine_type).each do |type|
          assert_select "select#deployment_#{type}[name=?]", "deployment[#{type}]"
        end
      end
    end
  end
end
