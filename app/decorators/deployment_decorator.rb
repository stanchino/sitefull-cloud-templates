class DeploymentDecorator
  attr_reader :deployment, :credentials

  def initialize(deployment)
    @deployment = deployment
    @credentials = CredentialsDecorator.new(credential)
  end

  def provider
    @provider ||= ProviderDecorator.new(deployment.provider, credentials_options).provider if deployment.provider.present?
  end

  def valid?
    @valid ||= provider.try(:valid?)
  end

  def regions
    valid? ? provider_regions.map(&:id) : []
  end

  def images
    valid? ? provider_images.map(&:id) : []
  end

  def machine_types
    valid? ? provider_machine_types.map(&:id) : []
  end

  def regions_for_select
    valid? ? provider_regions.sort_by(&:name) : []
  end

  def machine_types_for_select
    valid? ? provider_machine_types.sort_by(&:name) : []
  end

  def images_for_select
    valid? ? provider_images.sort_by(&:name) : []
  end

  def public_ip
    @public_ip ||= instance_data.try(:public_ip)
  end

  def instance_data
    @instance_data ||= provider.instance_data(deployment.instance_id)
  rescue
    nil
  end

  private

  def credential
    @credential ||= Credential.where(provider_id: deployment.provider_id, account_id: deployment.accounts_user.try(:account_id)).first_or_initialize
  end

  def credentials_options
    deployment.region.present? ? credentials.to_h.merge(region: deployment.region) : credentials.to_h
  end

  def provider_regions
    @regions ||= provider.regions
  rescue
    []
  end

  def provider_images
    @images ||= provider.images(deployment.os)
  rescue
    []
  end

  def provider_machine_types
    @machine_types ||= provider.machine_types(deployment.region)
  rescue
    []
  end
end
