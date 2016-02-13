module ControllerHelpers
  def login_user
    let(:user) { FactoryGirl.create(:user) }
    before(:each) { sign_in user }
  end

  def describe_regions_exception(exc)
    before { allow_any_instance_of(Aws::EC2::Client).to receive(:describe_regions).with(dry_run: true).and_raise(exc.new(double, double)) }
  end
end
