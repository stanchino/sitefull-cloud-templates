class DeploymentDecorator
  attr_accessor :deployment

  delegate :provider_type, to: :deployment

  def initialize(deployment)
    @deployment = deployment
  end

  def provider
    @provider ||= ProviderDecorator.new(deployment.provider_type, provider_options).provider if deployment.provider_type.present?
  end

  def valid?
    return @valid unless @valid.nil?
    @valid = provider.present? && provider.valid?
  end

  def regions
    valid? ? provider_regions.map(&:id) : []
  end

  def images
    valid? ? provider_images.map(&:id) : []
  end

  def machine_types
    valid? ? provider_machine_types.map(&:id) : []
  end

  def regions_for_select
    valid? ? provider_regions.sort_by(&:name) : []
  end

  def machine_types_for_select
    valid? ? provider_machine_types.sort_by(&:name) : []
  end

  def images_for_select
    valid? ? provider_images.sort_by(&:name) : []
  end

  private

  def provider_regions
    @regions ||= provider.regions
  end

  def provider_images
    @images ||= provider.images(deployment.os)
  end

  def provider_machine_types
    @machine_types ||= provider.machine_types(deployment.region)
  end

  def provider_options
    (deployment.credentials || {}).merge(token: access.token)
  end

  def access
    @access ||= Access.joins(:provider).where(Provider.arel_table[:textkey].eq(deployment.provider_type), user_id: deployment.user.id).first
  end
end
