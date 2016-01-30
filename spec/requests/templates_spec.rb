require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'Templates', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  before do
    login_as(user, scope: :user)
  end

  describe 'GET /templates' do
    it 'lists templates' do
      get '/templates'
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index, layout: 'dashboard')
    end
  end
end
