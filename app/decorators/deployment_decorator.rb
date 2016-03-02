class DeploymentDecorator
  attr_accessor :deployment

  delegate :regions, :regions_for_select,
           :flavors, :flavors_for_select,
           :images,  :images_for_select,
           :valid?, to: :@strategy

  def initialize(deployment)
    @deployment = deployment
    self.strategy = deployment.provider_type || 'base'
  end

  def strategy=(provider_type)
    @strategy = strategy_class(provider_type).new(deployment)
  end

  private

  def strategy_class(provider_type)
    "DeploymentDecorators::#{provider_type.capitalize}".constantize
  end
end
