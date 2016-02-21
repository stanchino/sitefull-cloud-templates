class Deployment < ActiveRecord::Base
  include Wisper::Publisher

  PROVIDERS = %w(aws google azure).freeze
  store_accessor :credentials, Provider::Aws::CREDENTIALS, Provider::Google::CREDENTIALS

  attr_encrypted :key_data, mode: :per_attribute_iv_and_salt, key: ENV['ENC_KEY'] || Rails.application.secrets.encryption_key

  belongs_to :template
  has_one :user, through: :template, inverse_of: :deployments

  validates :provider_type, presence: true, inclusion: PROVIDERS
  validates :region, presence: true, deployment: true
  validates :image, presence: true, deployment: true
  validates :flavor, presence: true, deployment: true

  validates :access_key_id, presence: true, if: -> { on?(:aws) }
  validates :secret_access_key, presence: true, if: -> { on?(:aws) }

  validates :google_auth, presence: true, if: -> { on?(:google) }

  delegate :os, to: :template

  def on?(provider)
    provider_type.present? && provider_type.to_s == provider.to_s
  end
end
