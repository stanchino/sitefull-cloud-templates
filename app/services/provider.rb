class Provider
  attr_accessor :type

  def initialize(type, options = {})
    @type = type
    @options = options.symbolize_keys if options.present?
    extend provider_module if type.present?
  end

  def regions
    []
  end

  def flavors
    []
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
