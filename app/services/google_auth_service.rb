require 'googleauth/web_user_authorizer'
require 'googleauth/stores/redis_token_store'

class GoogleAuthService
  SCOPE = ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/compute'].freeze

  def initialize(deployment)
    @deployment = deployment
    @user_id = deployment.user.to_param
  end

  def authorization_url(request)
    authorizer.get_authorization_url(login_hint: @user_id, request: request)
  end

  def authorize(request)
    credentials = credentials(request)
    if credentials.present?
      @deployment.provider_type = :google
      @deployment.credentials = { google_auth: credentials }
    end
  end

  def authorizer
    @authorizer ||= Google::Auth::WebUserAuthorizer.new(client_id, SCOPE, token_store, Rails.application.routes.url_helpers.google_auth_callback_path)
  end

  private

  def credentials(request)
    credentials = authorizer.get_credentials(@user_id, request)
    credentials.to_json if credentials.present?
  rescue StandardError
    nil
  end

  def token_store
    @token_store ||= Google::Auth::Stores::RedisTokenStore.new
  end

  def client_id
    @client_id ||= Google::Auth::ClientId.from_hash JSON.parse(ENV['GCE_CLIENT_SECRET'])
  end
end
