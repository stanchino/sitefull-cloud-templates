class ScriptDecorator
  attr_accessor :resource

  def initialize(resource)
    raise 'Resource does not have a script attribute' unless resource.respond_to?(:script)
    @resource = resource
  end

  def script_url
    @script_url ||= Aws::S3::Presigner.new.presigned_url(:get_object, bucket: :sitefull, key: s3_key)
  end

  def upload_script
    s3_cli.create_bucket(bucket: :sitefull)
    s3_cli.put_object(bucket: :sitefull, key: s3_key, body: process_script)
  end

  def remove_script
    s3_cli.delete_object(bucket: :sitefull, key: s3_key)
  end

  private

  def s3_cli
    @s3_cli ||= Aws::S3::Client.new
  end

  def s3_key
    @s3_key ||= "#{resource.class.to_s.tableize.singularize}_#{resource.id}"
  end

  def process_script
    script = resource.script
    resource.arguments.each { |key, value| script.gsub! "%{#{key}}", value.html_safe.gsub("'", "\\\'") } if resource.arguments.present?
    script.delete("\r")
  end
end
