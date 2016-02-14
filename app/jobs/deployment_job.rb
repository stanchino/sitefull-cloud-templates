class DeploymentJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(deployment_id)
    service = Deployment.find(deployment_id).service
    service.valid?
    create_network
    create_instance
    run_script
    at 100
    true
  end

  def create_network
    at 25, 'Creating network'
    Rails.logger.info 'Creating network'
  end

  def create_instance
    at 50, 'Creating instance'
    Rails.logger.info 'Creating instance'
  end

  def run_script
    at 75, 'Running the script on the instance'
    Rails.logger.info 'Running the script on the instance'
  end
end
