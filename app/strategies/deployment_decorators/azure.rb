module DeploymentDecorators
  class Azure < Base
    delegate :regions, :flavors, :images, to: :provider
  end
end
