# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'deployments/new', type: :view do
  let!(:template) { FactoryGirl.create(:template) }
  let!(:template_arguments) { FactoryGirl.create_list(:template_argument, 3, template: template) }
  let!(:providers) { Sitefull::Cloud::Provider::PROVIDERS.map { |type| FactoryGirl.create(:provider, type.to_sym, organization: template.user.organization) } }
  before do
    assign(:deployment, deployment)
    assign(:template, deployment.template)
    assign(:decorator, DeploymentDecorator.new(deployment))
    assign(:providers, template.user.organization.providers)
  end

  Sitefull::Cloud::Provider::PROVIDERS.each do |provider_type|
    let(:deployment) { FactoryGirl.build(:deployment, provider_type.to_sym, template: template) }
    it "renders the deployment form for #{provider_type}" do
      deployment.provider = providers.find { |pr| pr.textkey == provider_type }
      render

      assert_select String.new('form[action=?][method=?]'), template_deployments_path(deployment.template), 'post' do
        providers.each do |provider|
          if provider.textkey == provider_type
            assert_select String.new("input#deployment_provider_id_#{provider.id}[name=?][checked=checked]"), 'deployment[provider_id]'
          else
            assert_select String.new("input#deployment_provider_id_#{provider.id}[name=?]"), 'deployment[provider_id]'
          end
        end

        %w(region machine_type).each do |type|
          assert_select String.new("select#deployment_#{type}[name=?]"), "deployment[#{type}]"
        end

        template_arguments.each do |argument|
          assert_select String.new("input#deployment_arguments_#{argument.textkey}[name=?]"), "deployment[arguments][#{argument.textkey}]"
        end
      end
    end
  end
end
