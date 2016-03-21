class DeploymentInstanceListener
  def self.network_created(id, network_id)
    DeploymentInstanceService.new(Deployment.find(id)).create_firewall_rules(network_id)
  end

  def self.deployment_saved(id)
    DeploymentInstanceService.new(Deployment.find(id)).create_network
  end

  def self.deployment_network_saved(id)
    DeploymentInstanceService.new(Deployment.find(id)).create_key
  end

  def self.deployment_key_saved(id)
    DeploymentInstanceService.new(Deployment.find(id)).create_instance
  end

  def self.deployment_instance_saved(id)
    DeploymentInstanceService.new(Deployment.find(id)).finish_deployment
  end
end
