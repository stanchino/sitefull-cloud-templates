class DeploymentJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options queue: :deployments, retry: false

  def perform(deployment_id)
    service = DeploymentService.new Deployment.find(deployment_id)
    raise StandardError, I18n.t('deployments.jobs.errors.invalid_service') unless service.valid?
    create_network(service)
    create_key(service)
    create_instance(service)
    at 100, 'Done'
  end

  def create_network(service)
    at 0, 'Network Setup'
    service.create_network
  end

  def create_key(service)
    at 33, 'Generating key'
    service.create_key
  end

  def create_instance(service)
    at 67, 'Creating instance'
    service.create_instance
  end
end
