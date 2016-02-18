module Provider
  module Aws
    include Networking

    CREDENTIALS = [:access_key_id, :secret_access_key].freeze
    FLAVORS = %w(t2.nano t2.micro t2.small t2.medium t2.large m4.large m4.xlarge m4.2xlarge m4.4xlarge m4.10xlarge m3.medium m3.large m3.xlarge m3.2xlarge).freeze

    DEFAULT_REGION = 'us-east-1'.freeze
    DEFAULT_FLAVOR = 't2.micro'.freeze

    def connection
      @connection ||= ::Aws::EC2::Client.new(credentials.merge(region: DEFAULT_REGION))
    end

    def regions
      @regions ||= connection.describe_regions.regions
    end

    def flavors
      FLAVORS
    end

    def images(os)
      # IMAGES[os.to_sym]
      name = Hash[Template::OPERATING_SYSTEMS][os]
      connection.describe_images(filters: [{ name: 'name', values: ["#{name}*", "#{name.downcase}*"] }, { name: 'is-public', values: ['true'] }, { name: 'virtualization-type', values: ['hvm'] }]).images
    end

    def create_network
      setup_vpc
      setup_internet_gateway
      setup_routing
      setup_security_group
      subnet.subnet_id
    end

    def create_key(name)
      result = connection.create_key_pair(key_name: name)
      OpenStruct.new(name: result.key_name, data: result.key_material)
    end

    # Uses http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html#run_instances-instance_method
    def create_instance(image_id, instance_type, subnet_id, key_name)
      connection.run_instances(image_id: image_id, instance_type: instance_type, subnet_id: subnet_id, key_name: key_name, security_group_ids: [security_group.group_id], min_count: 1, max_count: 1).instances.first.instance_id
    end

    def valid?
      connection.describe_regions(dry_run: true)
    rescue ::Aws::EC2::Errors::DryRunOperation
      true
    rescue ::Aws::EC2::Errors::AuthFailure
      false
    rescue StandardError => e
      Rails.logger.info e.inspect
      false
    end
  end
end
