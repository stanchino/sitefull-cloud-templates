class DeploymentService
  include Wisper::Publisher

  attr_accessor :deployment, :provider

  delegate :regions, :flavors, :valid?, to: :provider

  def initialize(deployment)
    @deployment ||= deployment
    @provider = Provider::Factory.new(deployment.provider_type, deployment.credentials)
  end

  def images
    @images ||= provider.images(deployment.os)
  end
end
