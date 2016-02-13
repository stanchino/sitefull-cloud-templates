module Providers::Aws

  CREDENTIALS = [:access_key_id, :secret_access_key]
  FLAVORS = %w(t2.nano t2.micro t2.small t2.medium t2.large m4.large m4.xlarge m4.2xlarge m4.4xlarge m4.10xlarge m3.medium m3.large m3.xlarge m3.2xlarge).freeze
  DEFAULT_REGION = 'us-east-1'
  DEFAULT_FLAVOR = 't2.micro'

  def connection
    @connection ||= Aws::EC2::Client.new(credentials.merge(region: DEFAULT_REGION))
  end

  def regions
    connection.describe_regions.regions.map(&:region_name).sort
  end

  def flavors
    FLAVORS
  end

  def valid?
    begin
      connection.describe_regions(dry_run: true)
    rescue Aws::EC2::Errors::DryRunOperation
      true
    rescue Aws::EC2::Errors::AuthFailure
      false
    rescue StandardError => e
      Rails.logger.info e.inspect
      false
    end
  end
end
