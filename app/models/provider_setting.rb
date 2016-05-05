class ProviderSetting < ActiveRecord::Base
  belongs_to :provider

  attr_encrypted :value, mode: :per_attribute_iv_and_salt, key: ENV['ENC_KEY'] || Rails.application.secrets.encryption_key

  validates :name, presence: true, uniqueness: { scope: :provider_id }
  validates :value, presence: true
end
