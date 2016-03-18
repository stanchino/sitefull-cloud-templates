class DeploymentInstanceListener
  include Wisper::Publisher

  def self.network_created(id, network_id)
    WebsocketRails["deployment_#{id}"].trigger :network_created, id
    broadcast(:firewall_rules_created, id, SecureRandom.uuid)
    #DeploymentInstanceService.new(Deployment.find(id)).create_firewall_rules(network_id)
  end

  def self.deployment_saved(id)
    WebsocketRails["deployment_#{id}"].trigger :deployment_saved, id
    broadcast(:network_created, deployment.id, SecureRandom.uuid)
    #DeploymentInstanceService.new(Deployment.find(id)).create_network
  end

  def self.deployment_network_saved(id)
    WebsocketRails["deployment_#{id}"].trigger :network_saved, id
    broadcast(:key_created, id, 'name', 'data')
    #DeploymentInstanceService.new(Deployment.find(id)).create_key
  end

  def self.deployment_key_saved(id)
    WebsocketRails["deployment_#{id}"].trigger :key_saved, id
    broadcast(:instance_created, id, SecureRandom.uuid)
    #DeploymentInstanceService.new(Deployment.find(id)).create_instance
  end
end
