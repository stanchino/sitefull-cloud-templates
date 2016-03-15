RSpec.configure do |config|
  config.before(:suite) do
    [%w(Amazon amazon), %w(Azure azure), %w(Google google)].each do |name, textkey|
      provider = FactoryGirl.create(:provider, name: name, textkey: textkey)
      FactoryGirl.create(:provider_setting, name: 'client_id', value: 'client_id', provider: provider)
      FactoryGirl.create(:provider_setting, name: 'client_secret', value: 'client_secret', provider: provider)
      FactoryGirl.create(:provider_setting, name: 'tenant_id', value: 'tenant_id', provider: provider) if textkey == 'azure'
    end
  end
end
