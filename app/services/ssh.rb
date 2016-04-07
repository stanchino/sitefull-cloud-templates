module Services
  module Ssh
    def run_script
      ssh_session do |session|
        begin
          upload_script
          session.open_channel { |channel| execute_command channel }.wait
        rescue StandardError => e
          notify_progress "Error running the script: #{e.message}", :script_execution, :failed
        ensure
          remove_script
        end
      end
    end

    private

    def ssh_session
      Net::SSH.start(public_ip, deployment.ssh_user, timeout: 120, user_known_hosts_file: Tempfile.new.path, keys: [], key_data: [deployment.private_key], keys_only: true) { |session| yield(session) }
    end

    def upload_script
      s3_cli.create_bucket(bucket: :sitefull)
      s3_cli.put_object(bucket: :sitefull, key: s3_key, body: deployment.script.delete("\r"))
    end

    def remove_script
      s3_cli.delete_object(bucket: :sitefull, key: s3_key)
    end

    def execute_command(channel)
      channel.request_pty
      channel.exec("curl -sSL '#{script_url}' | sudo bash -") do |ch, success|
        if success
          notify_progress 'Script executed', :script_execution, :completed
          ch.on_data { |_, data| notify_output data }
          ch.on_extended_data { |_, _, data| notify_output "Error: #{data}" }
        else
          notify_progress 'Error running the script', :script_execution, :failed
        end
      end
    end

    def s3_cli
      @s3_cli ||= Aws::S3::Client.new
    end

    def s3_key
      @s3_key ||= "deployment_#{deployment.id}"
    end

    def script_url
      @script_url ||= Aws::S3::Presigner.new.presigned_url(:get_object, bucket: :sitefull, key: s3_key)
    end
  end
end
