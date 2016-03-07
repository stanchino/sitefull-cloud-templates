require 'rails_helper'
require 'shared_examples/deployments_controller'

RSpec.describe DeploymentsController, type: :controller do
  login_user

  let(:template) { FactoryGirl.create(:template, user: user) }
  let(:invalid_attributes) { { template_id: '' } }
  let(:valid_session) { {} }

  [:amazon, :azure, :google].each do |provider|
    describe "for #{provider}" do
      it_behaves_like 'deployment controller', provider
    end
  end
end
