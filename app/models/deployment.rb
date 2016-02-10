class Deployment < ActiveRecord::Base
  PROVIDERS = %w(aws google azure).freeze

  belongs_to :template
  belongs_to :deployment_credential
  has_one :credential, class_name: 'Credential', through: :deployment_credential, inverse_of: :deployments
  has_one :aws_credential, class_name: 'AwsCredential', through: :deployment_credential, inverse_of: :deployments
  accepts_nested_attributes_for :deployment_credential

  validates :provider, presence: true, inclusion: PROVIDERS
  validates :image, presence: true
  validates :flavor, presence: true

  delegate :user_id, to: :template
end
