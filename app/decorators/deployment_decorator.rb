class DeploymentDecorator
  delegate :deployment,
           :regions, :regions_for_select,
           :flavors, :flavors_for_select,
           :images,  :images_for_select,
           :options_for_selection, :valid?, to: :@provider

  def initialize(deployment)
    provider deployment.provider_type || 'base', for: deployment
  end

  def provider(provider_type, options = {})
    @provider = provider_class(provider_type).new provider_type, options[:for] || deployment
  end

  private

  def provider_class(provider_type)
    "DeploymentDecorators::#{provider_type.capitalize}".constantize
  end
end
