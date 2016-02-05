require 'rails_helper'
require 'shared_examples/controllers'

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
      it_behaves_like 'successful GET action', :user, 'dashboard/user', 'dashboard'
    end
  end
end
