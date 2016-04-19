class ConnectionDecorator
  attr_accessor :deployment, :decorator, :script_decorator

  def initialize(deployment)
    @deployment = deployment
    @decorator = DeploymentDecorator.new deployment
    @script_decorator = ScriptDecorator.new deployment
  end

  def wait_for_instance
    Timeout.timeout(300) do
      sleep 10 until instance_running?
    end
  end

  def execute_script
    ssh_session do |session|
      begin
        script_decorator.upload_script
        session.open_channel { |channel| execute_command channel }.wait
      rescue StandardError => e
        deployment.fail_with_error e.message
      ensure
        script_decorator.remove_script
      end
    end
  end

  private

  def instance_running?
    ssh_session(&:open_channel)
  rescue Net::SSH::ConnectionTimeout, Errno::ECONNREFUSED
    false
  end

  def key_data
    @key_data ||= OpenStruct.new(name: deployment.key_name, ssh_user: deployment.ssh_user, public_key: deployment.public_key)
  end

  def key_name
    @key_name ||= "deployment_#{deployment.id}"
  end

  def ssh_user
    deployment.provider_type.to_s == 'amazon' ? amazon_ssh_user : SSH_USER
  end

  def amazon_ssh_user
    case deployment.os
    when 'centos' then 'centos'
    when 'debian' then 'admin'
    when 'ubuntu' then 'ubuntu'
    else 'ec2-user'
    end
  end

  def ssh_session
    Net::SSH.start(decorator.public_ip, deployment.ssh_user, timeout: 30.seconds, user_known_hosts_file: Tempfile.new.path, keys: [], key_data: [deployment.private_key], keys_only: true) { |session| yield(session) }
  end

  def execute_command(channel)
    channel.request_pty
    channel.exec("curl -sSL '#{script_decorator.script_url}' | sudo bash -") do |ch, success|
      if success
        ch.on_data { |_, data| deployment.notify_output data }
        ch.on_extended_data { |_, _, data| deployment.notify_output "Error: #{data}" }
      else
        deployment.failed
      end
    end
  end
end
