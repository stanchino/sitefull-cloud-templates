module ControllerHelpers
  def login_user
    let(:user) { FactoryGirl.create(:user) }
    before(:each) { sign_in user }
  end

  def setup_access(provider_type)
    before(:each) { FactoryGirl.create(:access, user: user, provider: Provider.find_by_textkey(provider_type)) }
  end
end
