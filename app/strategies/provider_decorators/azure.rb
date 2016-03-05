module ProviderDecorators
  class Azure
    def options
      { tenant_id: ENV['AAD_TENANT_ID'], client_id: ENV['AAD_CLIENT_ID'], client_secret: ENV['AAD_CLIENT_SECRET'] }
    end
  end
end
