module DeploymentsHelper
  def provider_blank?
    @deployment.provider_type.blank?
  end

  def provider_options_urls
    Hash[[:regions, :images, :flavors].map { |item| ["#{item}-url", options_template_deployments_url(@template, type: item)] }]
  end

  def options_for_selection(provider_type)
    options = { checked: @deployment.provider_type == provider_type }
    return options if @deployment.token.present?

    options.merge(data: { 'oauth-url' => oauth_provider(provider_type).authorization_url.to_s })
  end
end
