class DeploymentService
  attr_accessor :deployment, :provider

  delegate :provider_type, :credentials, :image, :flavor, :network_id, :key_name, :instance_id, :public_ip, to: :deployment
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
      deployment.job_id = DeploymentJob.perform_async(deployment.id) if success
      success
    end
  end

  def create_network
    deployment.update_attributes(network_id: provider.create_network) unless network_id.present?
  end

  def create_key
    unless key_name.present?
      key = provider.create_key("deployment_#{deployment.id}")
      deployment.update_attributes(key_name: key.name, key_data: key.data)
    end
  end

  def create_instance
    deployment.update_attributes(instance_id: provider.create_instance(image, flavor, network_id, key_name)) unless instance_id.present?
  end

  def create_public_ip
    unless public_ip.present?
      provider.wait_for_status(instance_id, 'running')
      deployment.update_attributes(public_ip: provider.create_public_ip(instance_id))
    end
  end
end
