module DeploymentDecorators
  class Base
    attr_accessor :deployment
    delegate :valid?, to: :provider

    def initialize(provider_type, deployment)
      @provider_type = provider_type
      @deployment = deployment
    end

    def flavors
      []
    end

    def regions
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

    def options_for_selection(_request)
      { checked: deployment.provider_type == @provider_type }
    end

    protected

    def provider
      @provider ||= Provider::Factory.new @provider_type, @deployment.credentials
    end
  end
end
