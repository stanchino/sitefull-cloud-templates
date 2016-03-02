module DeploymentDecorators
  class Base
    attr_accessor :deployment, :provider
    delegate :valid?, to: :provider

    def initialize(deployment)
      @provider = ProviderDecorator.new(self.class.name.demodulize.downcase.to_sym, deployment.credentials).provider
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
  end
end
