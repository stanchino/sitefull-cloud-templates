require 'google/apis/compute_v1'

module Provider
  module Google
    CREDENTIALS = [:project_name, :google_auth].freeze
    FLAVORS = %w(t2.nano t2.micro t2.small t2.medium t2.large m4.large m4.xlarge m4.2xlarge m4.4xlarge m4.10xlarge m3.medium m3.large m3.xlarge m3.2xlarge).freeze

    DEFAULT_REGION = 'us-east-1'.freeze
    DEFAULT_FLAVOR = 't2.micro'.freeze

    def connection
      return @connection if @connection.present?
      auth_client = Signet::OAuth2::Client.new(JSON.parse(credentials[:google_auth]))
      @connection = ::Google::Apis::ComputeV1::ComputeService.new
      @connection.authorization = auth_client
      @connection
    end

    def project_name
      @project_name ||= credentials[:project_name]
    end

    def regions
      @regions ||= connection.list_zones(project_name).items
    end

    def flavors
      FLAVORS
    end

    def images(os)
      @images ||= (connection.list_images(project_name).items || []) + (connection.list_images("#{os}-cloud").items || [])
    end

    def create_network
      :network_id
    end

    def create_key(_name)
      OpenStruct.new(name: :key_name, data: :key_material)
    end

    def create_instance(_image_id, _instance_type, _subnet_id, _key_name)
      :instance_id
    end

    def valid?
      regions.any?
    rescue StandardError => e
      Rails.logger.info e.inspect
      false
    end
  end
end
