class ProviderDecorator
  delegate :authorize!, to: :auth

  def initialize(provider, options = {})
    @object = provider
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
