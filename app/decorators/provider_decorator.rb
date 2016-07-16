# frozen_string_literal: true
class ProviderDecorator
  delegate :authorize!, :token, to: :auth
  delegate :valid?, to: :provider

  def initialize(provider_object, options = {})
    @object = provider_object
    @options = options
  end

  def provider
    @provider ||= Sitefull::Cloud::Provider.new(@object.textkey, options)
  end

  def auth
    @auth ||= Sitefull::Cloud::Auth.new(@object.textkey, options)
  end

  def authorization_url
    auth.authorization_url.to_s
  end

  private

  def options
    token_options.merge(@options).symbolize_keys
  end

  def token_options
    @token_options ||= Hash[@object.settings.map { |s| [s.name, s.value] }]
  end
end
