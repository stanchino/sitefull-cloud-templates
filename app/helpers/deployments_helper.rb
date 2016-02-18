module DeploymentsHelper
  def provider_blank?
    @deployment.provider_type.blank?
  end

  def credentials_blank?
    Provider::Aws::CREDENTIALS.any? { |key| @deployment.send(key).blank? }
  end
end
