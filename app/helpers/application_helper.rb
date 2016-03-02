module ApplicationHelper
  def oauth_provider(provider_type)
    ProviderDecorator.new(provider_type).auth_provider(base_uri: request.base_url)
  end
end
