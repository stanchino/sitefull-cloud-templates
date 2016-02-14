class DeploymentService
  attr_accessor :deployment, :provider

  delegate :provider_type, :credentials, to: :deployment
  delegate :regions, :flavors, :valid?, to: :provider

  def initialize(deployment)
    @deployment ||= deployment
    @provider = Provider.new(provider_type, credentials)
  end

  def create
    ActiveRecord::Base.transaction do
      success = deployment.save
      deployment.job_id = DeploymentJob.perform_async(deployment.id)
      success
    end
  end
end
