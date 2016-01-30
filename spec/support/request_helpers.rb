include Warden::Test::Helpers

module RequestHelpers
  def login_user
    let(:user) { FactoryGirl.create(:user) }
    before do
      Warden.test_mode!
      login_as(user, scope: :user)
    end
    after do
      Warden.test_reset!
    end
  end
end
