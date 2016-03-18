class DeploymentStatusListener
  def self.firewall_rules_created(id, network_id)
    DeploymentStatusService.new(Deployment.find(id)).save_network_id(network_id)
  end

  def self.key_created(id, key_name, key_data)
    DeploymentStatusService.new(Deployment.find(id)).save_key(key_name, key_data)
  end

  def self.instance_created(id, instance_id)
    DeploymentStatusService.new(Deployment.find(id)).save_instance_id(instance_id)
  end
end
