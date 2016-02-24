require 'google/apis/compute_v1'

module Provider
  module Google
    CREDENTIALS = [:project_name, :google_auth].freeze
    FLAVORS = %w(https://www.googleapis.com/compute/v1/projects/sitefull-cloud/zones/us-central1-a/machineTypes/f1-micro).freeze

    DEFAULT_REGION = 'us-east-1'.freeze
    DEFAULT_FLAVOR = 't2.micro'.freeze

    def connection
      return @connection if @connection.present?

      connection = ::Google::Apis::ComputeV1::ComputeService.new
      connection.authorization = Signet::OAuth2::Client.new(JSON.parse(credentials[:google_auth]))
      @connection = connection
    end

    def project_name
      @project_name ||= credentials[:project_name]
    end

    def regions
      @regions ||= connection.list_zones(project_name).items
    end

    def flavors(zone)
      @flavors ||= connection.list_machine_types(project_name, zone).items
    rescue ::Google::Apis::ClientError
      []
    end

    def images(os)
      @images ||= project_images(project_name) + project_images("#{os}-cloud")
    end

    def create_network
      return network_id if network_id.present?

      network = ::Google::Apis::ComputeV1::Network.new(name: 'sitefull-cloud', i_pv4_range: '172.16.0.0/16')
      connection.insert_network(project_name, network).target_link
    end

    def create_firewall_rules(network_id)
      create_firewall_rule(network_id, 'sitefull-ssh', '22')
      create_firewall_rule(network_id, 'sitefull-http', '80')
      create_firewall_rule(network_id, 'sitefull-https', '443')
    end

    def create_key(_name)
      OpenStruct.new(name: :key_name, data: :key_material)
    end

    def create_instance(deployment)
      instance = ::Google::Apis::ComputeV1::Instance.new(name: "sitefull-deployment-#{deployment.id}", machine_type: deployment.flavor,
                                                         disks: [{ boot: true, autoDelete: true, initialize_params: { source_image: deployment.image } }],
                                                         network_interfaces: [{ network: deployment.network_id, access_configs: [{ name: 'default' }] }])
      connection.insert_instance(project_name, deployment.region, instance).target_link
    end

    def valid?
      regions.any?
    rescue StandardError => e
      Rails.logger.info e.inspect
      false
    end

    private

    def project_images(project)
      images = connection.list_images(project).items
      images.present? ? images.reject { |r| r.deprecated.present? && r.deprecated.state == 'DEPRECATED' } : []
    end

    def create_firewall_rule(network_id, rule_name, port)
      rule = ::Google::Apis::ComputeV1::Firewall.new(name: rule_name, source_ranges: ['0.0.0.0/0'], network: network_id, allowed: [{ ip_protocol: 'tcp', ports: [port] }])
      connection.insert_firewall(project_name, rule)
    end

    def network_id
      @network ||= connection.get_network(project_name, 'sitefull-cloud').self_link
    rescue ::Google::Apis::ClientError => e
      Rails.logger.debug(e.message)
      nil
    end
  end
end
