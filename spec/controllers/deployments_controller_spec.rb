require 'rails_helper'
require 'shared_examples/deployments_controller'

RSpec.describe DeploymentsController, type: :controller do
  login_user

  let(:template) { FactoryGirl.create(:template, user: user) }
  let(:invalid_attributes) { { template_id: '' } }
  let(:valid_session) { {} }

  describe 'with Amazon as provider', amazon: true do
    let(:deployment) { FactoryGirl.create(:deployment, :amazon, template: template) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:deployment, :amazon, template: template) }

    it_behaves_like 'deployment controller'
  end

  describe 'with Google as provider', google: true do
    let(:deployment) { FactoryGirl.create(:deployment, :google, template: template) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:deployment, :google, template: template, project_name: 'project') }

    it_behaves_like 'deployment controller'
  end

  describe 'with Azure as provider', azure: true do
    let(:deployment) { FactoryGirl.create(:deployment, :azure, template: template) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:deployment, :azure, template: template, subscription_id: 'subscription_id') }

    it_behaves_like 'deployment controller'
  end
end
