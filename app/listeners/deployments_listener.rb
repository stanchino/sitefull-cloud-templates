class DeploymentsListener
  class << self
    def create_network(id)
      deployment_service(id).provisioning_step :create_network
    end

    def create_firewall_rules(id)
      deployment_service(id).provisioning_step :create_firewall_rules
    end

    def create_access_key(id)
      deployment_service(id).provisioning_step :create_access_key
    end

    def create_instance(id)
      deployment_service(id).provisioning_step :create_instance
    end

    def start_instance(id)
      deployment_service(id).provisioning_step :start_instance
    end

    def execute_script(id)
      deployment_service(id).provisioning_step :execute_script
    end

    private

    def deployment_service(id)
      DeploymentService.new(Deployment.find(id))
    end
  end
end
