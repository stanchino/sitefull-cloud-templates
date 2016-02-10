class DeploymentCredential < ActiveRecord::Base
  has_one :deployment
  belongs_to :aws_credential, class_name: 'AwsCredential', foreign_key: 'credential_id', inverse_of: :deployment_credentials
  accepts_nested_attributes_for :aws_credential
end
