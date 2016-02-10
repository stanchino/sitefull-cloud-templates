class Credential < ActiveRecord::Base
  belongs_to :user
  has_many :deployment_credentials
  has_many :deployments, through: :deployment_credentials, inverse_of: :credential
end
