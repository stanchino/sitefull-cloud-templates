class DeploymentsListener
  class << self
    def deployment_saved(id)
      deployment_service(id).create_network
    end

    def network_created(id, network_id)
      deployment_service(id).create_firewall_rules(network_id)
    end

    def deployment_network_saved(id)
      deployment_service(id).create_key
    end

    def firewall_rules_created(id, network_id)
      deployment_service(id).save_network_id(network_id)
    end

    def key_created(id, key_name, ssh_user, public_key, private_key)
      deployment_service(id).save_key(key_name: key_name, ssh_user: ssh_user, public_key: public_key, private_key: private_key)
    end

    def deployment_key_saved(id)
      deployment_service(id).create_instance
    end

    def instance_created(id, instance_id)
      deployment_service(id).save_instance_id(instance_id)
    end

    def deployment_instance_saved(id)
      deployment_service(id).execute_script
    end

    def script_executed(id)
      deployment_service(id).finish_deployment
    end

    private

    def deployment_service(id)
      DeploymentService.new(Deployment.find(id))
    end
  end
end
