class DeploymentService
  include Wisper::Publisher

  SSH_USER = 'sitefull'.freeze

  attr_reader :deployment, :decorator, :connection_decorator

  delegate :provider, to: :decorator

  def initialize(deployment)
    @deployment = deployment
    @decorator = DeploymentDecorator.new deployment
    @connection_decorator = ConnectionDecorator.new deployment
  end

  def provisioning_step(step)
    send step
  rescue StandardError => e
    Rails.logger.error e.message
    deployment.fail_with_error e.message
  end

  protected

  def start
    deployment.change_state :started
    broadcast :create_network, deployment.id
  end

  def create_network
    deployment.change_state :network_created, network_id: network_id
    broadcast :create_firewall_rules, deployment.id
  end

  def create_firewall_rules
    provider.create_firewall_rules
    deployment.change_state :firewall_rules_created
    broadcast :create_access_key, deployment.id
  end

  def create_access_key
    deployment.change_state :access_key_created, key_name: key_name, ssh_user: ssh_user, public_key: ssh_key.public_key, private_key: ssh_key.private_key
    broadcast :create_instance, deployment.id
  end

  def create_instance
    deployment.change_state :instance_created, instance_id: instance_id
    broadcast :start_instance, deployment.id
  end

  def start_instance
    connection_decorator.wait_for_instance
    deployment.change_state :instance_started
    broadcast :execute_script, deployment.id
  end

  def execute_script
    connection_decorator.execute_script
    deployment.change_state :script_executed
  end

  private

  def network_id
    @network_id ||= provider.create_network
  end

  def ssh_key
    @ssh_key ||= provider.create_key key_name
  end

  def key_name
    @key_name ||= "deployment_#{deployment.id}"
  end

  def ssh_user
    deployment.provider_type.to_s == 'amazon' ? amazon_ssh_user : SSH_USER
  end

  def amazon_ssh_user
    case deployment.os
    when 'centos' then 'centos'
    when 'debian' then 'admin'
    when 'ubuntu' then 'ubuntu'
    else 'ec2-user'
    end
  end

  def key_data
    @key_data ||= OpenStruct.new(name: deployment.key_name, ssh_user: deployment.ssh_user, public_key: deployment.public_key)
  end

  def instance_id
    @instance_id ||= provider.create_instance(instance_name, deployment.machine_type, deployment.image, deployment.network_id, key_data)
  end

  def instance_name
    @instance_name ||= "sitefull-deployment-#{deployment.id}"
  end
end
