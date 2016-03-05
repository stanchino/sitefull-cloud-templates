class ProviderDecorator
  attr_reader :options

  def initialize(provider_type, opt = {})
    self.strategy = provider_type
    @options = @strategy.options.merge(opt)
    @auth_provider = Sitefull::Cloud::Auth.new(provider_type, @options)
  end

  def strategy=(provider_type)
    @strategy = provider_class(provider_type).new
  end

  def authorization_url
    @auth_provider.authorization_url.to_s
  end

  private

  def provider_class(provider_type)
    "ProviderDecorators::#{provider_type.capitalize}".constantize
  end
end
