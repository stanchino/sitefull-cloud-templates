module DeploymentsHelper
  def provider_blank?
    @deployment.provider.blank?
  end

  def credentials_blank?
    @deployment.credentials.blank? || @deployment.credentials.any?(&:blank?)
  end

  def selected_provider_is?(provider)
    @deployment.provider == provider
  end
end
