class DeploymentStatusService
  include Wisper::Publisher

  def initialize(deployment)
    @deployment ||= deployment
  end

  def save
    success = @deployment.save
    broadcast(:deployment_saved, @deployment.id) if success
    success
  end

  def save_network_id(network_id)
    @deployment.update_attributes(network_id: network_id)
    broadcast(:deployment_network_saved, @deployment.id)
  end

  def save_key(key_name, key_data)
    @deployment.update_attributes(key_name: key_name, key_data: key_data)
    broadcast(:deployment_key_saved, @deployment.id)
  end

  def save_instance_id(instance_id)
    @deployment.update_attributes(instance_id: instance_id)
    broadcast(:deployment_instance_saved, @deployment.id)
  end
end