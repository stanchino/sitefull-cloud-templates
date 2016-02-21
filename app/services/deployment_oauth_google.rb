require 'google/api_client/client_secrets'

class DeploymentOauthGoogle
  SCOPE = ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/compute'].freeze

  attr_accessor :deployment

  def initialize(deployment)
    @deployment = deployment
  end

  def save
    deployment.credentials = { google_auth: oauth_client.to_json }
    deployment.save(validate: false)
  end

  def authorization_uri
    oauth_client.authorization_uri.to_s
  end

  def oauth_client
    client_secrets = ::Google::APIClient::ClientSecrets.new JSON.parse(ENV['GCE_CLIENT_SECRET'])
    auth_client = client_secrets.to_authorization
    auth_client.update!(scope: SCOPE)
    auth_client
  end

  def authorize!(code)
    client_opts = JSON.parse(deployment.google_auth)
    auth_client = Signet::OAuth2::Client.new(client_opts)
    auth_client.code = code
    auth_client.fetch_access_token!
    deployment.update_column(:credentials, google_auth: auth_client.to_json)
  end
end
