class DeploymentService
  attr_accessor :deployment, :provider

  delegate :provider_type, :credentials, :image, :flavor, to: :deployment
  delegate :regions, :flavors, :valid?, :create_network, to: :provider

  def initialize(deployment)
    @deployment ||= deployment
    @provider = Provider.new(provider_type, credentials)
  end

  def images
    @images ||= provider.images(deployment.os)
  end

  def create
    ActiveRecord::Base.transaction do
      success = deployment.save
      deployment.job_id = DeploymentJob.perform_async(deployment.id)
      success
    end
  end

  def create_instance
    provider.create_instance image, flavor
  end
end
