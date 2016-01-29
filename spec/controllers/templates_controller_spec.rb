require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe TemplatesController, type: :controller do
  login_user

  # This should return the minimal set of attributes required to create a valid
  # Template. As you add validations to Template, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:template, user: user)
  end

  let(:invalid_attributes) do
    { name: '', script: '', user: user }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TemplatesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all templates as @templates' do
      template = Template.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:templates)).to eq([template])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested template as @template' do
      template = Template.create! valid_attributes
      get :show, { id: template.to_param }, valid_session
      expect(assigns(:template)).to eq(template)
    end
  end

  describe 'GET #new' do
    it 'assigns a new template as @template' do
      get :new, {}, valid_session
      expect(assigns(:template)).to be_a_new(Template)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested template as @template' do
      template = Template.create! valid_attributes
      get :edit, { id: template.to_param }, valid_session
      expect(assigns(:template)).to eq(template)
    end
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

      it 'redirects to the created template' do
        post :create, { template: valid_attributes }, valid_session
        expect(response).to redirect_to(Template.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved template as @template' do
        post :create, { template: invalid_attributes }, valid_session
        expect(assigns(:template)).to be_a_new(Template)
      end

      it "re-renders the 'new' template" do
        post :create, { template: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        FactoryGirl.attributes_for(:template, user: user)
      end

      it 'updates the requested template' do
        template = Template.create! valid_attributes
        put :update, { id: template.to_param, template: new_attributes }, valid_session
        template.reload
        expect(template.name).to eq new_attributes[:name]
        expect(template.script).to eq new_attributes[:script]
      end

      it 'assigns the requested template as @template' do
        template = Template.create! valid_attributes
        put :update, { id: template.to_param, template: valid_attributes }, valid_session
        expect(assigns(:template)).to eq(template)
      end

      it 'redirects to the template' do
        template = Template.create! valid_attributes
        put :update, { id: template.to_param, template: valid_attributes }, valid_session
        expect(response).to redirect_to(template)
      end
    end

    context 'with invalid params' do
      it 'assigns the template as @template' do
        template = Template.create! valid_attributes
        put :update, { id: template.to_param, template: invalid_attributes }, valid_session
        expect(assigns(:template)).to eq(template)
      end

      it "re-renders the 'edit' template" do
        template = Template.create! valid_attributes
        put :update, { id: template.to_param, template: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested template' do
      template = Template.create! valid_attributes
      expect do
        delete :destroy, { id: template.to_param }, valid_session
      end.to change(Template, :count).by(-1)
    end

    it 'redirects to the templates list' do
      template = Template.create! valid_attributes
      delete :destroy, { id: template.to_param }, valid_session
      expect(response).to redirect_to(templates_url)
    end
  end
end
