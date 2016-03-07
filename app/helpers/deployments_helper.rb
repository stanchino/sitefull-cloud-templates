module DeploymentsHelper
  def provider_blank?
    @deployment.provider_type.blank?
  end

  def provider_options_urls
    Hash[[:regions, :images, :machine_types].map { |item| ["#{item}-url", options_template_deployments_url(@template, type: item)] }]
  end

  def options_for_selection(provider_type)
    options = { checked: @deployment.provider_type == provider_type }

    options.merge(data: { 'oauth-url' => ProviderDecorator.new(provider_type, oauth_url_options(provider_type)).authorization_url })
  end

  private

  def oauth_url_options(provider_type)
    { base_uri: request.base_url, state: new_template_deployment_path(@deployment.template, provider: provider_type) }
  end
end
