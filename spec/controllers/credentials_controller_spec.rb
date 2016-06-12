require 'rails_helper'
require 'shared_examples/controllers'

RSpec.describe CredentialsController, type: :controller do
  login_admin
  let!(:template) { FactoryGirl.create(:template, user: user) }

  [:amazon, :azure, :google].each do |provider_type|
    describe "for #{provider_type}" do
      render_views
      let(:provider) { FactoryGirl.create(:provider, provider_type, organization: user.organization) }
      before do
        FactoryGirl.create(:provider_setting, name: 'client_id', value: 'client_id', provider: provider)
        FactoryGirl.create(:provider_setting, name: 'client_secret', value: 'client_secret', provider: provider)
        FactoryGirl.create(:provider_setting, name: 'tenant_id', value: 'tenant_id', provider: provider)
      end

      describe 'GET #auth' do
        before { expect_any_instance_of(ProviderDecorator).to receive(:authorize!).with('code').and_return(true) }

        it 'assigns the variables' do
          get :auth, provider_textkey: provider_type, code: 'code', state: template.id
          expect_assignments
        end

        describe 'for existing credentials' do
          before { FactoryGirl.create(:credential, provider_type.to_sym, provider: provider, account: user.current_account) }
          context 'when credentials are not valid' do
            before { expect_any_instance_of(ProviderDecorator).to receive(:valid?).and_return('error') }
            it 'renders the auth view' do
              get :auth, provider_textkey: provider_type, code: 'code', state: template.id
              expect(response).to render_template('auth', layout: 'dashboard')
            end
          end

          context 'when credentials validation raises an error' do
            before { expect_any_instance_of(ProviderDecorator).to receive(:valid?).and_raise(StandardError) }
            it 'renders the auth view' do
              get :auth, provider_textkey: provider_type, code: 'code', state: template.id
              expect(response).to render_template('auth', layout: 'dashboard')
            end
          end

          context 'when credentials are valid' do
            before { expect_any_instance_of(ProviderDecorator).to receive(:valid?).and_return(true) }
            it 'redirects to the new deployment page' do
              get :auth, provider_textkey: provider_type, code: 'code', state: template.id
              expect(response).to redirect_to new_template_deployment_path(template.to_param, provider: provider_type)
            end
          end
        end

        describe 'for new credentials' do
          context 'when credentials are not valid' do
            before { expect_any_instance_of(ProviderDecorator).to receive(:valid?).and_return(false) }
            it 'renders the auth view' do
              get :auth, provider_textkey: provider_type, code: 'code', state: template.id
              expect(response).to render_template('auth', layout: 'dashboard')
            end
          end

          context 'when credentials are valid' do
            before { expect_any_instance_of(ProviderDecorator).to receive(:valid?).and_return(true) }
            it 'redirects to the new deployment page' do
              get :auth, provider_textkey: provider_type, code: 'code', state: template.id
              expect(response).to render_template('auth', layout: 'dashboard')
            end
          end
        end
      end

      describe 'GET #new' do
        context 'without access token' do
          before { get :new, provider_textkey: provider_type, state: template.id }

          it 'assigns the variables' do
            expect_assignments
            expect(assigns(:credential)).not_to be_persisted
          end

          it 'redirects to the authorization URL' do
            expect(response).to redirect_to assigns(:provider_decorator).authorization_url
          end
        end

        context 'with access token' do
          context 'without a valid credential' do
            let(:authorization_url) { 'http://example.com/auth' }
            before do
              expect_any_instance_of(Sitefull::Cloud::Auth).to receive(:authorization_url).and_return(authorization_url)
              expect_any_instance_of(Sitefull::Cloud::Auth).to receive_message_chain(:token, :access_token).and_return(true)
              get :new, provider_textkey: provider_type, state: template.id
            end

            it 'assigns the variables' do
              expect_assignments
              expect(assigns(:credential)).to be_a_new Credential
            end

            it 'redirects to the new deployment URL' do
              expect(response).to redirect_to authorization_url
            end
          end

          context 'with a valid credential' do
            let!(:credential) { FactoryGirl.create(:credential, provider_type, account: user.current_account, provider: provider) }
            before do
              expect_any_instance_of(Sitefull::Cloud::Auth).to receive_message_chain(:token, :access_token).and_return(true)
              get :new, provider_textkey: provider_type, state: template.id
            end

            it 'assigns the variables' do
              expect_assignments
              expect(assigns(:credential)).to eq credential
            end

            it 'redirects to the new deployment URL' do
              expect(response).to redirect_to new_template_deployment_path(template.id, provider: provider_type)
            end
          end
        end
      end

      describe 'POST #create' do
        let!(:valid_attributes) { FactoryGirl.attributes_for(:credential, provider_type, provider: provider, account: user.current_account) }
        let!(:invalid_attributes) { {} }

        context 'with valid attributes' do
          it 'creates a new credential' do
            expect do
              post :create, provider_textkey: provider_type, credential: valid_attributes, state: template.id
            end.to change(Credential, :count).by(1)
          end

          it 'assigns a newly created credential as @credential' do
            post :create, provider_textkey: provider_type, credential: valid_attributes, state: template.id
            expect_assignments
            expect(assigns(:credential)).to be_persisted
          end

          context 'with HTML format' do
            it 'redirects to the newly created record' do
              post :create, provider_textkey: provider_type, credential: valid_attributes, state: template.id
              expect(response).to redirect_to new_template_deployment_path(template.id, provider: provider_type)
            end
          end
        end

        context 'with invalid params' do
          it 'assigns a newly created but unsaved credential as @credential' do
            post :create, provider_textkey: provider_type, credential: invalid_attributes, state: template.id
            expect_assignments
            expect(assigns(:credential)).not_to be_persisted
          end

          context 'for HTML requests' do
            it "re-renders the 'new' view" do
              post :create, provider_textkey: provider_type, credential: invalid_attributes, state: template.id
              expect(response).to render_template('new', layout: 'dashboard')
            end
          end
        end
      end

      describe 'PUT #update' do
        let!(:credential) { FactoryGirl.create(:credential, provider_type, token: 'foo', provider: provider, account: user.current_account) }
        let!(:valid_attributes) { FactoryGirl.attributes_for(:credential, provider_type, provider: provider, account: user.current_account) }
        let!(:invalid_attributes) { {} }

        context 'with valid attributes' do
          it 'assigns variables' do
            put :update, provider_textkey: provider_type, id: credential.id, credential: valid_attributes, state: template.id
            expect_assignments
            expect(assigns(:credential)).to be_persisted
          end

          context 'with HTML format' do
            it 'redirects to the deployment URL' do
              put :update, provider_textkey: provider_type, id: credential.id, credential: valid_attributes, state: template.id
              expect(response).to redirect_to new_template_deployment_path(template.id, provider: provider_type)
            end
          end
        end

        context 'with invalid params' do
          before { expect_any_instance_of(Credential).to receive(:valid?).and_return(false) }
          it 'assigns variables' do
            put :update, provider_textkey: provider_type, id: credential.id, credential: invalid_attributes, state: template.id
            expect_assignments
            expect(assigns(:credential)).to be_persisted
          end

          context 'for HTML requests' do
            it "re-renders the 'edit' view" do
              put :update, provider_textkey: provider_type, id: credential.id, credential: invalid_attributes, state: template.id
              expect(response).to render_template('edit', layout: 'dashboard')
            end
          end
        end
      end
    end
  end
end

def expect_assignments
  expect(assigns(:template)).to eq template.to_param
  expect(assigns(:provider)).to eq provider
  expect(assigns(:credential)).to be_a Credential
end
