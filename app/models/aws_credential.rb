class AwsCredential < Credential
  store :credentials, accessors: [:aws_access_key_id, :aws_secret_access_key]

  validates :aws_access_key_id, presence: true
  validates :aws_secret_access_key, presence: true
end
