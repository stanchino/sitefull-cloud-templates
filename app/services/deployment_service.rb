class DeploymentService
  attr_accessor :deployment, :provider

  delegate :provider_type, :credentials, :image, :flavor, to: :deployment
  delegate :regions, :flavors, :valid?, to: :provider

  def initialize(deployment)
    @deployment ||= deployment
    @provider = Provider.new(provider_type, credentials)
  end

  def images
    @images ||= provider.images(deployment.os)
  end

  def create
    ActiveRecord::Base.transaction do
      success = deployment.save
      deployment.job_id = DeploymentJob.perform_async(deployment.id)
      success
    end
  end

  def create_network
    return deployment.network_id if deployment.network_id.present?
    network_id = provider.create_network
    deployment.update_attributes(network_id: network_id)
  end

  def create_instance
    return deployment.instance_id if deployment.instance_id.present?
    instance_id = provider.create_instance(image, flavor, deployment.network_id)
    deployment.update_attributes(instance_id: instance_id)
  end
end
