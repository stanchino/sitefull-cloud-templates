module Decorators
  module Aws
    delegate :flavors, to: :service

    def regions
      service.regions.map(&:region_name)
    end

    def images
      service.images.map(&:image_id)
    end

    def regions_for_select
      service.regions.sort_by(&:region_name).map { |r| OpenStruct.new(id: r.region_name, name: r.region_name) }
    end

    def flavors_for_select
      service.flavors.map { |f| OpenStruct.new(id: f, name: f) }
    end

    def images_for_select
      service.images.sort_by(&:image_id).map { |i| OpenStruct.new(id: i.image_id, name: i.name) }
    end
  end
end
