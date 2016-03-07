class DeploymentInstanceService
  include Wisper::Publisher

  attr_accessor :deployment, :provider

  def initialize(deployment)
    @deployment ||= deployment
    @provider = DeploymentDecorator.new(deployment).provider
  end

  def create_network
    network_id = provider.create_network
    broadcast(:network_created, deployment.id, network_id)
  end

  def create_firewall_rules(network_id)
    provider.create_firewall_rules(network_id)
    broadcast(:firewall_rules_created, deployment.id, network_id)
  end

  def create_key
    key = provider.create_key("deployment_#{deployment.id}")
    broadcast(:key_created, deployment.id, key.name, key.data)
  end

  def create_instance
    instance_id = provider.create_instance(deployment)
    broadcast(:instance_created, deployment.id, instance_id)
  end
end
