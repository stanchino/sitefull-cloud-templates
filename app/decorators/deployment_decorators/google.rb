module DeploymentDecorators
  class Google < Base
    def regions
      provider.regions.map(&:name)
    end

    def images
      provider.images(deployment.os).map(&:self_link)
    end

    def flavors
      provider.flavors(deployment.region).map(&:self_link)
    end

    def regions_for_select
      provider.regions.sort_by(&:name).map { |r| OpenStruct.new(id: r.name, name: r.name) }
    end

    def flavors_for_select
      provider.flavors(deployment.region).map { |f| OpenStruct.new(id: f.self_link, name: f.name) }
    end

    def images_for_select
      provider.images(deployment.os).sort_by(&:name).map { |i| OpenStruct.new(id: i.self_link, name: i.name) }
    end

    def options_for_selection(request)
      return super unless deployment.google_auth.nil?
      super.merge(data: { 'oauth-url' => GoogleAuthService.new(deployment).authorization_url(request) })
    end
  end
end
