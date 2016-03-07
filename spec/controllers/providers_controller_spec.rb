require 'rails_helper'

RSpec.describe ProvidersController, type: :controller do
  login_user
  before { expect_any_instance_of(Sitefull::Cloud::Auth).to receive(:authorize!).and_return(true) }

  [:amazon, :azure, :google].each do |provider|
    context "for #{provider}" do
      it 'creates an access record' do
        expect do
          get :oauth, id: provider, code: 'code', state: 'state'
        end.to change(Access, :count).by(1)
      end

      it 'redirects to the state url' do
        get :oauth, id: provider, code: 'code', state: 'state'
        expect(response).to redirect_to 'state'
      end
    end
  end
end
