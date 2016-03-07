class Access < ActiveRecord::Base
  belongs_to :provider
  belongs_to :user

  attr_encrypted :token, mode: :per_attribute_iv_and_salt, key: ENV['ENC_KEY']
end
