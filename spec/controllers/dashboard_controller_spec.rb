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
      verify_success :user, 'dashboard/user', 'dashboard'
    end
  end
end
