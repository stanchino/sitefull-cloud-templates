module ControllerHelpers
  def login_user
    let(:user) { FactoryGirl.create(:user) }
    before(:each) { sign_in user }
  end
end
