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

    def options_for_selection
      deployment.google_auth.present? ? {} : { 'data-oauth-url' => authorization_uri }
    end

    private

    def authorization_uri
      Rails.application.routes.url_helpers.google_auth_template_deployments_path(deployment.template)
    end
  end
end
