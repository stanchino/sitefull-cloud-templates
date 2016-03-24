module Services
  module Instance
    def create_network
      notify_progress 'Creating Network', :network_setup, :running
      network_id = provider.create_network
      broadcast(:network_created, deployment.id, network_id)
    end

    def create_firewall_rules(network_id)
      notify_progress 'Network Setup', :network_setup, :completed
      notify_progress 'Creating Firewall Rules', :firewall_setup, :running
      provider.create_firewall_rules
      broadcast(:firewall_rules_created, deployment.id, network_id)
    end

    def create_key
      notify_progress 'Firewall Setup', :firewall_setup, :completed
      notify_progress 'Creating Access Keys', :access_setup, :running
      name = "deployment_#{deployment.id}"
      key = provider.create_key(name)
      broadcast(:key_created, deployment.id, name, key.ssh_user, key.public_key, key.private_key)
    end

    def create_instance
      notify_progress 'Access Keys Setup', :access_setup, :completed
      notify_progress 'Creating Instance', :instance_setup, :running
      instance_id = create_instance_result
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

    def create_instance_result
      provider.create_instance(instance_name, deployment.machine_type, deployment.image, deployment.network_id, key_data)
    end

    def instance_name
      "sitefull-deployment-#{deployment.id}"
    end

    def key_data
      OpenStruct.new(name: deployment.key_name, ssh_user: deployment.ssh_user, public_key: deployment.public_key)
    end
  end
end
