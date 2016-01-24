require 'rails_helper'

describe DashboardController, type: :controller do
  describe 'GET #user' do
    describe 'for unauthenticated' do
      it 'blocks access' do
        get :user
        expect(response).to redirect_to new_user_session_url
      end
    end
    describe 'for authenticated user' do
      login_user
      it 'allows access' do
        get :user
        expect(response).to be_success
        expect(response).to render_template 'dashboard/user', layout: 'dashboard'
      end
    end
  end
end
