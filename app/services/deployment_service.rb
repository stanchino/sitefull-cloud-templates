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
      DeploymentJob.perform_later(deployment) if success
      success
    end
  end
end
