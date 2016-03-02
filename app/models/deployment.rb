class Deployment < ActiveRecord::Base
  PROVIDERS = %w(amazon google azure).freeze
  store_accessor :credentials, [:token] + PROVIDERS.map { |provider| "Provider::#{provider.capitalize}::REQUIRED_OPTIONS".constantize }.flatten

  attr_encrypted :key_data, mode: :per_attribute_iv_and_salt, key: ENV['ENC_KEY'] || Rails.application.secrets.encryption_key

  belongs_to :template
  has_one :user, through: :template, inverse_of: :deployments

  validates :provider_type, presence: true, inclusion: PROVIDERS
  validates :region, presence: true, deployment: true
  validates :image, presence: true, deployment: true
  validates :flavor, presence: true, deployment: true

  validates_with ProviderOptionsValidator

  delegate :os, to: :template

  def on?(provider)
    provider_type.present? && provider_type.to_s == provider.to_s
  end
end
