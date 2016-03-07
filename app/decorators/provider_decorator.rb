class ProviderDecorator
  def initialize(provider_type, opt = {})
    @provider_model = Provider.find_by_textkey(provider_type)
    @provider_type = provider_type
    @options = token_options.merge(opt).symbolize_keys
  end

  def provider
    @provider ||= Sitefull::Cloud::Provider.new(@provider_type, @options)
  end

  def auth
    @auth ||= Sitefull::Cloud::Auth.new(@provider_type, @options)
  end

  def token_options
    @token_options ||= Hash[@provider_model.settings.map { |s| [s.name, s.value] }]
  end

  def authorization_url
    auth.authorization_url.to_s
  end

  delegate :authorize!, to: :auth
end
