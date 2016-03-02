module ProviderDecorators
  class Amazon < Base
    def options
      { client_id: ENV['AMAZON_CLIENT_ID'], client_secret: ENV['AMAZON_CLIENT_SECRET'] }
    end
  end
end
