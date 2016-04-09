require 'rails_helper'
require 'shared_examples/controllers'

RSpec.describe ProvidersController, type: :controller do
  describe 'oauth' do
    login_user
    before { expect_any_instance_of(Sitefull::Cloud::Auth).to receive(:authorize!).and_return(true) }

    [:amazon, :azure, :google].each do |provider|
      context "for #{provider}" do
        it 'creates an access record' do
          expect do
            get :oauth, id: provider, code: 'code', state: 'state'
          end.to change(Access, :count).by(1)
        end

        it 'redirects to the state url' do
          get :oauth, id: provider, code: 'code', state: 'state'
          expect(response).to redirect_to 'state'
        end
      end
    end
  end

  describe 'CRUD' do
    login_admin
    before { Provider.destroy_all }

    let(:valid_session) { {} }
    let(:valid_attributes) { { name: 'Provider', textkey: 'azure' } }
    let(:invalid_attributes) { { name: '', textkey: '' } }

    describe 'GET #index' do
      let(:providers) { Array.new(3) { |i| Provider.where(textkey: Sitefull::Cloud::Provider::PROVIDERS[i]).first_or_create.tap { |p| p.update_attributes(name: "Provider #{i}") } } }
      it 'assigns all providers as @providers' do
        get :index, {}, valid_session
        expect(assigns(:providers)).to match_array providers
      end
    end

    describe 'GET #new' do
      it 'assigns a new provider as @provider' do
        get :new, {}, valid_session
        expect(assigns(:provider)).to be_a_new(Provider)
      end
    end

    describe 'GET #edit' do
      let(:provider) { create_provider }
      it_behaves_like 'successfull GET resource action', :edit, :provider, 'providers/edit', 'dashboard', false
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new provider' do
          expect do
            post :create, { provider: valid_attributes }, valid_session
          end.to change(Provider, :count).by(1)
        end

        it 'assigns a newly created provider as @provider' do
          post :create, { provider: valid_attributes }, valid_session
          expect(assigns(:provider)).to be_a(Provider)
          expect(assigns(:provider)).to be_persisted
        end

        context 'with HTML format' do
          it 'redirects to the created provider' do
            post :create, { provider: valid_attributes }, valid_session
            expect(response).to redirect_to(edit_provider_url(Provider.last))
          end
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved provider as @provider' do
          post :create, { provider: invalid_attributes }, valid_session
          expect(assigns(:provider)).to be_a_new(Provider)
        end

        context 'for HTML requests' do
          it "re-renders the 'new' provider" do
            post :create, { provider: invalid_attributes }, valid_session
            expect(response).to render_template('new', layout: 'dashboard')
          end
        end

        context 'for JSON requests' do
          it 'sets the correct HTTP header' do
            post :create, { provider: invalid_attributes, format: :json }, valid_session
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'generates an error' do
            post :create, { provider: invalid_attributes, format: :json }, valid_session
            expect(response.body).to eq assigns(:provider).errors.to_json
          end
        end
      end
    end

    describe 'PUT #update' do
      let(:provider) { create_provider }
      context 'with valid params' do
        let(:new_attributes) { { name: 'New Name' } }

        it 'updates the requested provider' do
          put :update, { id: provider.to_param, provider: new_attributes }, valid_session
          provider.reload
          expect(provider.name).to eq new_attributes[:name]
        end

        it_behaves_like 'update action with data', :provider, :valid_attributes

        context 'for HTML requests' do
          it 'redirects to the provider' do
            put :update, { id: provider.to_param, provider: valid_attributes }, valid_session
            expect(response).to redirect_to(providers_url)
          end
        end
      end

      context 'with invalid params' do
        it_behaves_like 'update action with data', :provider, :invalid_attributes

        context 'for HTML requests' do
          it "re-renders the 'edit' provider" do
            put :update, { id: provider.to_param, provider: invalid_attributes }, valid_session
            expect(response).to render_template('edit')
          end
        end

        context 'for JSON requests' do
          it 'sets the correct HTTP header' do
            put :update, { id: provider.to_param, provider: invalid_attributes, format: :json }, valid_session
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'generates an error' do
            put :update, { id: provider.to_param, provider: invalid_attributes, format: :json }, valid_session
            expect(response.body).to eq assigns(:provider).errors.to_json
          end
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:provider) { create_provider }
      it 'destroys the requested provider' do
        id = provider.to_param
        expect do
          delete :destroy, { id: id }, valid_session
        end.to change(Provider, :count).by(-1)
      end

      it 'redirects to the providers list' do
        delete :destroy, { id: provider.to_param }, valid_session
        expect(response).to redirect_to(providers_url)
      end
    end
  end
end

def create_provider
  Provider.where(textkey: Sitefull::Cloud::Provider::PROVIDERS.sample).first_or_create.tap do |provider|
    provider.name = 'Provider'
    provider.save!
  end
end
