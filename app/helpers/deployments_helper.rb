module DeploymentsHelper
  def provider_blank?
    @deployment.provider_type.blank?
  end

  def credentials_blank?
    Provider::Aws::CREDENTIALS.any? { |key| @deployment.send(key).blank? }
  end

  def provider_options_urls
    Hash[[:regions, :images, :flavors].map { |item| ["#{item}-url", options_template_deployments_url(@template, type: item)] }]
  end
end
