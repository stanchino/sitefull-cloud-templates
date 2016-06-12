class Deployment < ActiveRecord::Base
  include DeploymentStateMachine

  store_accessor :arguments

  attr_encrypted :public_key, mode: :per_attribute_iv_and_salt, key: ENV['ENC_KEY'] || Rails.application.secrets.encryption_key
  attr_encrypted :private_key, mode: :per_attribute_iv_and_salt, key: ENV['ENC_KEY'] || Rails.application.secrets.encryption_key

  belongs_to :template
  belongs_to :accounts_user
  belongs_to :provider
  has_one :user, through: :accounts_user
  has_one :account, through: :accounts_user

  validates_with DeploymentArgumentsValidator
  validates :provider, presence: true
  validates :accounts_user, presence: true
  validates :region, presence: true, deployment: true
  validates :image, presence: true, deployment: true
  validates :machine_type, presence: true, deployment: true

  delegate :os, :script, to: :template
  delegate :textkey, to: :provider, prefix: :provider, allow_nil: true
end
