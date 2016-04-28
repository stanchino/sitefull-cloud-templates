class Deployment < ActiveRecord::Base
  include DeploymentStateMachine

  store_accessor :credentials, Sitefull::Cloud::Provider.all_required_options

  attr_encrypted :public_key, mode: :per_attribute_iv_and_salt, key: ENV['ENC_KEY'] || Rails.application.secrets.encryption_key
  attr_encrypted :private_key, mode: :per_attribute_iv_and_salt, key: ENV['ENC_KEY'] || Rails.application.secrets.encryption_key

  belongs_to :template
  has_one :user, through: :template, inverse_of: :deployments

  validates :provider_type, presence: true, inclusion: Sitefull::Cloud::Provider::PROVIDERS
  validates :region, presence: true, deployment: true
  validates :image, presence: true, deployment: true
  validates :machine_type, presence: true, deployment: true

  validates_with ProviderOptionsValidator

  delegate :os, :script, to: :template

  def on?(provider)
    provider_type.present? && provider_type.to_s == provider.to_s
  end
end
