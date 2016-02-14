class DeploymentDecorator
  attr_accessor :service

  def initialize(deployment)
    @deployment = deployment
    @service = DeploymentService.new(deployment)
    extend decorator_name.constantize if deployment.provider_type
  end

  def regions
    []
  end

  def flavors
    []
  end

  def images
    []
  end

  def regions_for_select
    []
  end

  def flavors_for_select
    []
  end

  def images_for_select
    []
  end

  private

  def decorator_name
    "Decorators::#{@deployment.provider_type.capitalize}"
  end
end
