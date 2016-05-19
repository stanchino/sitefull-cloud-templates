require 'rails_helper'
require 'shared_examples/controllers'

RSpec.describe CredentialsController, type: :controller do
  login_admin

  describe 'oauth' do
    before { expect_any_instance_of(ProviderDecorator).to receive(:authorize!).with('code').and_return(true) }

    [:amazon, :azure, :google].each do |provider_type|
      context "for #{provider_type}" do
        render_views
        let(:provider) { FactoryGirl.create(:provider, provider_type, organization: user.organization) }
        before do
          FactoryGirl.create(:provider_setting, name: 'client_id', value: 'client_id', provider: provider)
          FactoryGirl.create(:provider_setting, name: 'client_secret', value: 'client_secret', provider: provider)
          FactoryGirl.create(:provider_setting, name: 'tenant_id', value: 'tenant_id', provider: provider)
          get :auth, provider_textkey: provider_type, code: 'code', state: 'state'
        end

        it 'assigns the decorator' do
          expect(assigns(:provider_decorator)).to be_a ProviderDecorator
        end

        it 'assigns the credential object' do
          expect(assigns(:credential)).to be_a_new Credential
        end

        it 'renders the auth view' do
          expect(response).to render_template('auth', layout: 'dashboard')
        end
      end
    end
  end
end
