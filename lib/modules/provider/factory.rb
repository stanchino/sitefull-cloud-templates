module Provider
  class Factory
    def initialize(type, options = {})
      @options = options.symbolize_keys unless options.nil?
      @type = type || 'base'
      extend(provider_module)
    end

    protected

    def credentials
      @credentials ||= Hash[provider_credentials.map { |key| [key, @options[key]] }]
    end

    private

    def provider_module
      @provider_module ||= "Provider::#{@type.capitalize}".constantize
    end

    def provider_credentials
      @provider_credentials ||= provider_module::CREDENTIALS
    end
  end
end
