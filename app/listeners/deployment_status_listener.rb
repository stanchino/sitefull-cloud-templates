class DeploymentStatusListener
  def self.firewall_rules_created(id, network_id)
    DeploymentStatusService.new(Deployment.find(id)).save_network_id(network_id)
  end

  def self.key_created(id, key_name, ssh_user, public_key, private_key)
    DeploymentStatusService.new(Deployment.find(id)).save_key(key_name: key_name, ssh_user: ssh_user, public_key: public_key, private_key: private_key)
  end

  def self.instance_created(id, instance_id)
    DeploymentStatusService.new(Deployment.find(id)).save_instance_id(instance_id)
  end
end
