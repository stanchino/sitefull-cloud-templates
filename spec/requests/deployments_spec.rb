# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Deployments', type: :request do
  describe 'GET /deployments' do
    login_user
    it 'works! (now write some real specs)' do
      get deployments_path
      expect(response).to have_http_status(:ok)
    end
  end
end
