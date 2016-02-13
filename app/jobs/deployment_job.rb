class DeploymentJob < ActiveJob::Base
  queue_as :deployments

  def perform(deployment)
    Rails.logger.info "Deploying #{deployment.inspect}"
    true
  end
end
