require_relative 'instance'
require_relative 'deployment'

class DeploymentService
  include Wisper::Publisher
  include Services::Instance
  include Services::Deployment

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
