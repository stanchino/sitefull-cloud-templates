require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  login_user

  describe 'Google auth callback' do
    let(:template) { FactoryGirl.create(:template, user: user) }
    before { session[:template_id] = template.id }

    context 'when deployment is missing' do
      before { get :google_auth_callback, code: :code }

      it { is_expected.to redirect_to(new_template_deployment_path(template)) }
      it { is_expected.to set_flash[:alert].to 'Deployment not found.' }
      it { expect(session[:template_id]).to be_nil }
    end

    context 'when the code is invalid' do
      let(:deployment) { FactoryGirl.create(:deployment, provider_type: :google, template: template) }
      before do
        session[:deployment_id] = deployment.id
        expect_any_instance_of(Signet::OAuth2::Client).to receive(:fetch_access_token!).and_raise(Signet::AuthorizationError.new(any_args))
        get :google_auth_callback, code: :code
      end

      it { is_expected.to redirect_to(new_template_deployment_path(template)) }
      it { is_expected.to set_flash[:alert].to 'Google authorization failure.' }
      it { expect(session[:template_id]).to be_nil }
    end

    context 'when the code is valid' do
      let(:deployment) { FactoryGirl.create(:deployment, provider_type: :google, template: template) }
      before do
        session[:deployment_id] = deployment.id
        expect_any_instance_of(Signet::OAuth2::Client).to receive(:fetch_access_token!).and_return(true)
        get :google_auth_callback, code: :code
      end

      it { is_expected.to redirect_to(edit_template_deployment_path(template, deployment)) }
      it { is_expected.not_to set_flash }
      it { expect(session[:template_id]).to be_nil }
      it { expect(session[:deployment_id]).to be_nil }
    end
  end
end
