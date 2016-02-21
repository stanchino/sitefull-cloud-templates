module DeploymentDecorators
  class Aws < Base
    delegate :flavors, :regions, :valid?, to: :provider

    def regions
      provider.regions.map(&:region_name)
    end

    def images
      provider.images(deployment.os).map(&:image_id)
    end

    def regions_for_select
      provider.regions.sort_by(&:region_name).map { |r| OpenStruct.new(id: r.region_name, name: r.region_name) }
    end

    def flavors_for_select
      provider.flavors.map { |f| OpenStruct.new(id: f, name: f) }
    end

    def images_for_select
      provider.images(deployment.os).sort_by(&:image_id).map { |i| OpenStruct.new(id: i.image_id, name: i.name) }
    end
  end
end
