class DeploymentInstanceListener
  def self.deployment_saved(id)
    DeploymentInstanceService.new(Deployment.find(id)).create_network
  end

  def self.deployment_network_saved(id)
    DeploymentInstanceService.new(Deployment.find(id)).create_key
  end

  def self.deployment_key_saved(id)
    DeploymentInstanceService.new(Deployment.find(id)).create_instance
  end
end
