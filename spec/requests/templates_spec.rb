# frozen_string_literal: true
require 'rails_helper'
require 'shared_examples/requests'

RSpec.describe 'Template actions', type: :request do
  let(:valid_params) { { name: 'Template', os: 'debian', script: Faker::Lorem.paragraph } }

  describe 'without access' do
    context 'when listing templates' do
      before { get templates_path }
      it_behaves_like 'unauthenticated user'
    end
    context 'when creating a template' do
      before { post templates_path, template: valid_params }
      it_behaves_like 'unauthenticated user'
    end
  end

  describe 'for authenticated user' do
    login_user
    context 'can manage templates' do
      it 'using JSON requests' do
        post templates_path, template: valid_params, format: :json
        expect(response).to be_created
        get templates_path
        expect(response).to be_success
        expect(response).to render_template('templates/index', layout: false)
      end

      it 'using HTML requests' do
        expect do
          post templates_path, template: valid_params
        end.to change(Template, :count).by(1)
        template = Template.last
        expect(response).to redirect_to template_path(template)
        follow_redirect!
        expect(response).to be_success
        expect(response).to render_template('templates/show', layout: 'application')
        expect(response.body).to include valid_params[:name]
        expect(response.body).to include Hash[Template::OPERATING_SYSTEMS][valid_params[:os]]
      end
    end
  end
end
