class DeploymentJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options queue: :deployments, retry: false

  def perform(deployment_id)
    service = DeploymentService.new Deployment.find(deployment_id)
    raise StandardError, I18n.t('deployments.jobs.errors.invalid_service') unless service.valid?
    create_network(service)
    create_instance(service)
  end

  def create_network(service)
    at 25, 'Creating network'
    service.create_network
    at 50, 'Network created'
  end

  def create_instance(service)
    at 75, 'Creating instance'
    service.create_instance
    at 100, 'Instance created'
  end
end
