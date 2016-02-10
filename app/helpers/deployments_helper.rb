module DeploymentsHelper
  def provider_blank?
    @deployment.provider.blank?
  end

  def credentials_blank?
    @deployment.deployment_credential.blank? || @deployment.deployment_credential.aws_credential.blank?
  end

  def selected_provider_is?(provider)
    @deployment.provider == provider
  end
end
