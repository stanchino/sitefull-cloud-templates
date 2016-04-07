module Services
  module Instance
    SSH_USER = 'sitefull'.freeze

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
      broadcast(:key_created, deployment.id, name, ssh_user, key.public_key, key.private_key)
    end

    def create_instance
      notify_progress 'Access Keys Setup', :access_setup, :completed
      notify_progress 'Creating Instance', :instance_setup, :running
      instance_id = create_instance_result
      broadcast(:instance_created, deployment.id, instance_id)
    end

    def execute_script
      notify_progress 'Instance Created', :instance_setup, :completed
      notify_progress 'Starting the script', :script_execution, :running
      run_script
      broadcast(:script_executed, deployment.id)
    end

    def finish_deployment
      notify_progress 'Script Created', :script_execution, :completed
      deployment.update_attributes(status: :completed)
      notify_status 'completed'
    end

    def public_ip
      @public_ip ||= provider.instance_data(deployment.instance_id).public_ip
    end

    # def public_dns
    #  @public_dns ||= Resolv.getname(public_ip)
    # end

    private

    def notify_progress(message, key, status)
      WebsocketRails[:deployments].trigger :progress, id: deployment.id, message: message, key: key, status: status
    end

    def notify_status(status)
      WebsocketRails[:deployments].trigger :status, id: deployment.id, status: status
    end

    def notify_output(message)
      WebsocketRails[:deployments].trigger :output, id: deployment.id, message: message
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

    def ssh_user
      if deployment.provider_type.to_s == 'amazon'
        amazon_ssh_user
      else
        SSH_USER
      end
    end

    def amazon_ssh_user
      case deployment.os
      when 'centos'
        'centos'
      when 'debian'
        'admin'
      when 'ubuntu'
        'ubuntu'
      else
        'ec2-user'
      end
    end
  end
end
