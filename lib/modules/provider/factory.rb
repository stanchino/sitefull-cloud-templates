module Provider
  class Factory
    attr_reader :type, :options

    def initialize(type, options = {})
      @options = options.symbolize_keys unless options.nil?
      @type = type || 'base'
      extend(provider_module)
    end

    protected

    def credentials
      @credentials ||= Sitefull::Oauth::Provider.new(type, options).credentials
    end

    private

    def provider_module
      @provider_module ||= "Provider::#{@type.capitalize}".constantize
    end
  end
end
