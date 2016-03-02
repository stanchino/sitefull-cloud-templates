module ProviderDecorators
  class Base
    attr_accessor :provider

    def initialize(credentials = {})
      @provider = Provider::Factory.new(self.class.name.demodulize.downcase.to_sym, credentials)
    end

    def auth_provider(opt = {})
      @auth_provider ||= Sitefull::Oauth::Provider.new(self.class.name.demodulize.downcase.to_sym, options.merge(opt))
    end
  end
end
