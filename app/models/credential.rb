class Credential < ActiveRecord::Base
  belongs_to :provider
  belongs_to :account

  store_accessor :data, Sitefull::Cloud::Provider.all_required_options

  attr_encrypted :token, mode: :per_attribute_iv_and_salt,
                         key: ENV['ENC_KEY'] || Rails.application.secrets.encryption_key

  validates_with ProviderOptionsValidator
end
