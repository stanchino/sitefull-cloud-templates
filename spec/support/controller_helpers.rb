module ControllerHelpers
  def login_user
    let(:user) { FactoryGirl.create(:user) }
    before(:each) { sign_in user }
  end

  def verify_success(action, template, layout)
    it 'renders the page' do
      get action
      expect(response).to be_success
      expect(response).to render_template template, layout: layout
    end
  end
end
