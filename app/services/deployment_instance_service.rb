class DeploymentInstanceService
  include Wisper::Publisher

  attr_accessor :deployment, :provider

  def initialize(deployment)
    @deployment ||= deployment
    @provider = DeploymentDecorator.new(deployment).provider
  end

  def create_network
    notify_progress 'Creating Network', :network_setup, :running
    network_id = provider.create_network
    broadcast(:network_created, deployment.id, network_id)
  end

  def create_firewall_rules(network_id)
    WebsocketRails[:deployments].trigger :progress, id: deployment.id, message: 'Network Setup', key: :network_setup, status: :completed
    WebsocketRails[:deployments].trigger :progress, id: deployment.id, message: 'Creating Firewall Rules', key: :firewall_setup, status: :running
    notify_progress 'Network Setup', :network_setup, :completed
    notify_progress 'Creating Firewall Rules', :firewall_setup, :running
    provider.create_firewall_rules(network_id)
    broadcast(:firewall_rules_created, deployment.id, network_id)
  end

  def create_key
    notify_progress 'Firewall Setup', :firewall_setup, :completed
    notify_progress 'Creating Access Keys', :access_setup, :running
    key = provider.create_key("deployment_#{deployment.id}")
    broadcast(:key_created, deployment.id, key.name, key.data)
  end

  def create_instance
    notify_progress 'Access Keys Setup', :access_setup, :completed
    notify_progress 'Creating Instance', :instance_setup, :running
    instance_id = provider.create_instance(deployment)
    broadcast(:instance_created, deployment.id, instance_id)
  end

  def finish_deployment
    notify_progress 'Instance Created', :instance_setup, :completed
    deployment.update_attributes(status: :completed)
    notify_status 'completed'
  end

  private

  def notify_progress(message, key, status)
    WebsocketRails[:deployments].trigger :progress, id: deployment.id, message: message, key: key, status: status
  end

  def notify_status(status)
    WebsocketRails[:deployments].trigger :status, id: deployment.id, status: status
  end
end
