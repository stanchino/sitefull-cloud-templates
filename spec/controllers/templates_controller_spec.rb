require 'rails_helper'
require 'shared_examples/controllers'

RSpec.describe TemplatesController, type: :controller do
  login_user

  let(:template) { FactoryGirl.create(:template, user: user) }
  let(:templates) { FactoryGirl.create_list(:template, 5, user: user) }

  let(:valid_session) { {} }
  let(:valid_attributes) { FactoryGirl.attributes_for(:template, user: user) }
  let(:invalid_attributes) { { name: '', os: '', script: '' } }

  describe 'GET #index' do
    it 'assigns all templates as @templates' do
      get :index, {}, valid_session
      expect(assigns(:templates)).to match_array templates
    end
  end

  describe 'GET #new' do
    it 'assigns a new template as @template' do
      get :new, {}, valid_session
      expect(assigns(:template)).to be_a_new(Template)
    end
  end

  describe 'GET #show' do
    it_behaves_like 'successfull GET resource action', :show, :template, 'templates/show', 'dashboard', true
  end

  describe 'GET #edit' do
    it_behaves_like 'successfull GET resource action', :edit, :template, 'templates/edit', 'dashboard', false
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Template' do
        expect do
          post :create, { template: valid_attributes }, valid_session
        end.to change(Template, :count).by(1)
      end

      it 'assigns a newly created template as @template' do
        post :create, { template: valid_attributes }, valid_session
        expect(assigns(:template)).to be_a(Template)
        expect(assigns(:template)).to be_persisted
      end

      it 'assigns the current user to the template' do
        post :create, { template: valid_attributes }, valid_session
        expect(assigns(:template).user).to eq user
      end

      context 'with HTML format' do
        it 'redirects to the created template' do
          post :create, { template: valid_attributes }, valid_session
          expect(response).to redirect_to(Template.last)
        end
      end

      context 'with JSON format' do
        it 'returns the correct HTTP code' do
          post :create, { template: valid_attributes, format: :json }, valid_session
          expect(response).to be_created
        end

        it 'renders the newly created template' do
          post :create, { template: valid_attributes, format: :json }, valid_session
          expect(response).to render_template('templates/show', layout: false)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved template as @template' do
        post :create, { template: invalid_attributes }, valid_session
        expect(assigns(:template)).to be_a_new(Template)
      end

      context 'for HTML requests' do
        it "re-renders the 'new' template" do
          post :create, { template: invalid_attributes }, valid_session
          expect(response).to render_template('new', layout: 'dashboard')
        end
      end

      context 'for JSON requests' do
        it 'sets the correct HTTP header' do
          post :create, { template: invalid_attributes, format: :json }, valid_session
          expect(response).to have_http_status(422)
        end

        it 'generates an error' do
          post :create, { template: invalid_attributes, format: :json }, valid_session
          expect(response.body).to eq assigns(:template).errors.to_json
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { FactoryGirl.attributes_for(:template, user: user) }

      it 'updates the requested template' do
        put :update, { id: template.to_param, template: new_attributes }, valid_session
        template.reload
        expect(template.name).to eq new_attributes[:name]
        expect(template.os).to eq new_attributes[:os]
        expect(template.script).to eq new_attributes[:script]
      end

      it_behaves_like 'update action with data', :template, :valid_attributes

      context 'for HTML requests' do
        it 'redirects to the template' do
          put :update, { id: template.to_param, template: valid_attributes }, valid_session
          expect(response).to redirect_to(template)
        end
      end

      context 'for JSON requests' do
        it 'sets the success HTTP header' do
          put :update, { id: template.to_param, template: valid_attributes, format: :json }, valid_session
          expect(response).to be_success
        end

        it 'returns the updated template' do
          put :update, { id: template.to_param, template: valid_attributes, format: :json }, valid_session
          expect(response.body).to render_template('show', layout: false)
        end
      end
    end

    context 'with invalid params' do
      it_behaves_like 'update action with data', :template, :invalid_attributes

      context 'for HTML requests' do
        it "re-renders the 'edit' template" do
          put :update, { id: template.to_param, template: invalid_attributes }, valid_session
          expect(response).to render_template('edit')
        end
      end

      context 'for JSON requests' do
        it 'sets the correct HTTP header' do
          put :update, { id: template.to_param, template: invalid_attributes, format: :json }, valid_session
          expect(response).to have_http_status(422)
        end

        it 'generates an error' do
          put :update, { id: template.to_param, template: invalid_attributes, format: :json }, valid_session
          expect(response.body).to eq assigns(:template).errors.to_json
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested template' do
      id = template.to_param
      expect do
        delete :destroy, { id: id }, valid_session
      end.to change(Template, :count).by(-1)
    end

    it 'redirects to the templates list' do
      delete :destroy, { id: template.to_param }, valid_session
      expect(response).to redirect_to(templates_url)
    end
  end
end
