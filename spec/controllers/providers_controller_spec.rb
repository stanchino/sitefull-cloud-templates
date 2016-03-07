require 'rails_helper'

RSpec.describe ProvidersController, type: :controller do
  login_user
  before { expect_any_instance_of(Sitefull::Cloud::Auth).to receive(:authorize!).and_return(true) }

  Provider.all.each do |provider|
    context "for #{provider.name}" do
      it 'creates an access record' do
        expect do
          get :oauth, id: provider.textkey, code: 'code', state: 'state'
        end.to change(Access, :count).by(1)
      end

      it 'redirects to the state url' do
        get :oauth, id: provider.textkey, code: 'code', state: 'state'
        expect(response).to redirect_to 'state'
      end
    end
  end
end
