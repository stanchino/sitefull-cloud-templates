class EventController < WebsocketRails::BaseController
  def trigger_deployment
    deployment = Deployment.find(data[:deployment_id])
    deployment.reset
    DeploymentService.new(deployment).provisioning_step :start
  end
end
