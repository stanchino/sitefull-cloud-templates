require_relative 'instance'
require_relative 'deployment'
require_relative 'ssh'

class DeploymentService
  include Wisper::Publisher
  include Services::Instance
  include Services::Deployment
  include Services::Ssh

  attr_accessor :deployment, :provider

  delegate :regions, :machine_types, :valid?, to: :provider

  def initialize(deployment)
    @deployment = deployment
    @provider = DeploymentDecorator.new(deployment).provider
  end

  def images
    @images ||= provider.images(deployment.os)
  end
end
