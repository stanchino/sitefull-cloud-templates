module DeploymentsHelper
  def provider_blank?
    @deployment.provider_type.blank?
  end

  def provider_options_urls
    Hash[[:regions, :images, :machine_types].map { |item| ["#{item}-url", options_template_deployments_url(@template, type: item)] }]
  end

  def options_for_selection(provider_type)
    options = { checked: @deployment.provider_type == provider_type }
    return options if @deployment.token.present?

    options.merge(data: { 'oauth-url' => ProviderDecorator.new(provider_type, base_uri: request.base_url).authorization_url })
  end
end
