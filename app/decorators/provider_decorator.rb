class ProviderDecorator
  attr_accessor :credentials

  delegate :auth_provider, :provider, to: :@strategy

  def initialize(provider_type, credentials = {})
    @credentials = credentials
    self.strategy = provider_type
  end

  def strategy=(provider_type)
    @strategy = provider_class(provider_type).new(credentials)
  end

  private

  def provider_class(provider_type)
    "ProviderDecorators::#{provider_type.capitalize}".constantize
  end
end
