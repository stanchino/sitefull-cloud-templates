class Provider
  def initialize(type, options = {})
    @options = options.symbolize_keys unless options.nil?
    @type = type
    extend provider_module unless type.nil?
  end

  def regions
    []
  end

  def flavors
    []
  end

  def valid?
    false
  end

  protected

  def credentials
    @credentials ||= Hash[provider_credentials.map { |key| [key, @options[key]] }]
  end

  private

  def provider_module
    "Providers::#{@type.capitalize}".constantize
  end

  def provider_credentials
    provider_module::CREDENTIALS
  end
end
