# frozen_string_literal: true
module ControllerHelpers
  def login_user
    let(:user) { FactoryGirl.create(:user) }
    before(:each) { sign_in user }
  end

  def login_admin
    let(:user) { FactoryGirl.create(:user, admin: true) }
    before(:each) { sign_in user }
  end

  def setup_credentials(provider_type)
    before(:each) { FactoryGirl.create(:credential, provider_type.to_sym, account: user.current_account, provider: Provider.find_by_textkey(provider_type)) }
  end
end
