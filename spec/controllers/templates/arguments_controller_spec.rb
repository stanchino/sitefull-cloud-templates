# frozen_string_literal: true
require 'rails_helper'
require 'shared_examples/controllers'

RSpec.describe Templates::ArgumentsController, type: :controller do
  login_user
  render_views

  let(:template) { FactoryGirl.create(:template, user: user) }
  let(:templates) { FactoryGirl.create_list(:template, 5, user: user) }
  let(:argument) { FactoryGirl.create(:template_argument, template: template) }

  let(:valid_session) { {} }

  describe 'GET #new' do
    context 'for HTML requests' do
      before { get :new, { template_id: template.id }, valid_session }

      it 'assigns the template as @template' do
        expect(assigns(:template)).to eq template
      end

      it 'assigns a new argument' do
        expect(assigns(:argument)).to be_a_new(TemplateArgument)
      end

      it 'renders the new view' do
        expect(response).to render_template('templates/arguments/new', layout: false)
      end
    end
  end

  describe 'GET #edit' do
    context 'for HTML requests' do
      subject { response }

      before { get :edit, { template_id: template.to_param, id: argument.to_param }, valid_session }

      it 'assigns the template as @template' do
        expect(assigns(:template)).to eq template
      end

      it 'assigns a new argument' do
        expect(assigns(:argument)).to eq argument
      end

      it 'renders the edit view' do
        expect(response).to render_template('templates/arguments/edit', layout: false)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested argument' do
      id = argument.to_param
      expect do
        delete :destroy, { template_id: template.to_param, id: id }, valid_session
      end.to change(TemplateArgument, :count).by(-1)
    end

    it 'redirects to the arg list' do
      delete :destroy, { template_id: template.to_param, id: argument.to_param }, valid_session
      expect(response).to redirect_to(edit_template_url(template))
    end
  end
end
