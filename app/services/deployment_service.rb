class DeploymentService
  include Wisper::Publisher

  attr_accessor :deployment, :provider

  delegate :regions, :machine_types, :valid?, to: :provider

  def initialize(deployment)
    @deployment ||= deployment
    @provider = Sitefull::Cloud::Provider.new(deployment.provider_type, deployment.credentials)
  end

  def images
    @images ||= provider.images(deployment.os)
  end
end
