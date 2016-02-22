module DeploymentDecorators
  class Google < Base
    delegate :flavors, to: :provider

    def regions
      provider.regions.map(&:name)
    end

    def images
      provider.images(deployment.os).map(&:id)
    end

    def regions_for_select
      provider.regions.sort_by(&:name).map { |r| OpenStruct.new(id: r.id, name: r.name) }
    end

    def flavors_for_select
      provider.flavors.map { |f| OpenStruct.new(id: f, name: f) }
    end

    def images_for_select
      provider.images(deployment.os).sort_by(&:name).map { |i| OpenStruct.new(id: i.id, name: i.name) }
    end

    def options_for_selection(request)
      return super if deployment.google_auth.present?

      service = DeploymentOauthGoogle.new(deployment)
      super.merge(data: { 'oauth-url' => service.authorization_url(request) })
    end
  end
end
