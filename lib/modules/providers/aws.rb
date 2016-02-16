module Providers
  module Aws
    CREDENTIALS = [:access_key_id, :secret_access_key].freeze
    FLAVORS = %w(t2.nano t2.micro t2.small t2.medium t2.large m4.large m4.xlarge m4.2xlarge m4.4xlarge m4.10xlarge m3.medium m3.large m3.xlarge m3.2xlarge).freeze
    IMAGES = {
      debian: [
        OpenStruct.new(image_id: 'ami-43a59129', name: 'Debian Jessie')
      ],
      freebsd: [],
      centos: [],
      rhel: [],
      suse: [],
      ubuntu: [],
      windows_2003: [],
      windows_2008: [],
      windows_2012: [],
      other: []
    }.freeze
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
      IMAGES[os.to_sym]
      # name = Hash[Template::OPERATING_SYSTEMS][os]
      # connection.describe_images(filters: [{ name: 'name', values: [name, "*#{name}*"] }, { name: 'virtualization-type', values: ['hvm'] }]).images
    end

    def create_network
      attach_internet_gateway unless internet_gateways.any?
      setup_network_access
      connection.create_subnet(vpc_id: vpc.vpc_id, cidr_block: '10.0.0.0/28').subnet.subnet_id
    end

    def create_key(name)
      result = connection.create_key_pair(key_name: name)
      OpenStruct.new(name: result.key_name, data: result.key_material)
    end

    # Uses http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html#run_instances-instance_method
    def create_instance(image_id, instance_type, subnet_id, key_name)
      connection.run_instances(image_id: image_id, instance_type: instance_type, subnet_id: subnet_id, key_name: key_name, security_group_ids: [security_group.group_id], min_count: 1, max_count: 1).instances.first.instance_id
    end

    def create_public_ip(instance_id)
      address = connection.allocate_address(domain: 'vpc')
      connection.associate_address(instance_id: instance_id, allocation_id: address.allocation_id)
      address.public_ip
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

    protected

    def get_status(instance_id)
      last_status = connection.describe_instance_status(instance_ids: [instance_id]).instance_statuses.last
      last_status.instance_state.name if last_status.present?
    end

    private

    def vpc
      @vpc ||= vpcs.any? ? vpcs.last : create_vpc
    end

    def vpcs
      @vpcs ||= connection.describe_vpcs.vpcs.select { |v| v.tags.map(&:value).include? 'SiteFull Deployment' }
    end

    def create_vpc
      vpc = connection.create_vpc(cidr_block: '10.0.0.0/28').vpc
      connection.create_tags resources: [vpc.vpc_id], tags: [{ key: 'name', value: 'SiteFull Deployment' }]
      vpc
    end

    def internet_gateway
      @internet_gateway ||= internet_gateways.any? ? internet_gateways.last : connection.create_internet_gateway.internet_gateway
    end

    def internet_gateways
      @internet_gateways ||= connection.describe_internet_gateways.internet_gateways.select { |i| i.attachments.map(&:vpc_id).include? vpc.vpc_id }
    end

    def attach_internet_gateway
      connection.attach_internet_gateway(internet_gateway_id: internet_gateway.internet_gateway_id, vpc_id: vpc.vpc_id)
    end

    def route_table
      @route_table ||= route_tables.any? ? route_tables.last : connection.create_route_table(vpc_id: vpc.vpc_id).route_table
    end

    def route_tables
      @route_tables ||= connection.describe_route_tables.route_tables.select { |rt| rt.vpc_id == vpc.vpc_id }
    end

    def security_group
      @group_id ||= security_groups.any? ? security_groups.last : connection.create_security_group(group_name: 'SiteFull Security Group', description: 'Security Group for SiteFull deployments', vpc_id: vpc.vpc_id)
    end

    def security_groups
      @security_groups ||= connection.describe_security_groups.security_groups.select { |sg| sg.vpc_id == vpc.vpc_id }
    end

    def setup_network_access
      connection.create_route(route_table_id: route_table.route_table_id, destination_cidr_block: '0.0.0.0/0', gateway_id: internet_gateway.internet_gateway_id)
      connection.authorize_security_group_ingress(group_id: security_group.group_id, ip_protocol: 'tcp', from_port: 22, to_port: 22, cidr_ip: '0.0.0.0/0')
    end
  end
end
