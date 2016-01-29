require 'rails_helper'

describe 'Templates', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  before { login_as(user) }

  describe 'GET /templates' do
    it 'works! (now write some real specs)' do
      get templates_path
      expect(response).to have_http_status(200)
    end
  end
end
