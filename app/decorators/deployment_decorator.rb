class DeploymentDecorator
  attr_accessor :deployment, :provider
  delegate :valid?, to: :provider

  def initialize(deployment)
    @provider = Sitefull::Cloud::Provider.new(deployment.provider_type, deployment.credentials)
    @deployment = deployment
  end

  def regions
    provider.regions.map(&:id)
  end

  def images
    provider.images(deployment.os).map(&:id)
  end

  def machine_types
    provider.machine_types(deployment.region).map(&:id)
  end

  def regions_for_select
    provider.regions.sort_by(&:name)
  end

  def machine_types_for_select
    provider.machine_types(deployment.region).sort_by(&:name)
  end

  def images_for_select
    provider.images(deployment.os).sort_by(&:name)
  end
end
