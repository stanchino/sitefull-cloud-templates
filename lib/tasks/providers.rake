namespace :sitefull do
  namespace :providers do
    desc 'Add provider'
    task :add, [:name, :textkey] => :environment do |_t, args|
      name = args[:name]
      textkey = args[:textkey]
      unless name.present? && textkey.present?
        puts 'Usage rake sitefull:providers:add[name,textkey]'
        exit 1
      end
      unless Sitefull::Cloud::Provider::PROVIDERS.include? textkey.to_s
        puts 'The provider textkey is not supported'
        exit 1
      end
      settings = []
      print 'Enter Client ID: '
      settings << [:client_id, STDIN.gets]
      print 'Enter Client Secret: '
      settings << [:client_secret, STDIN.gets]
      if textkey == 'azure'
        print 'Enter Tenant ID: '
        settings << [:tenant_id, STDIN.gets]
      end
      puts "Creating provider #{name} with textkey #{textkey}"
      begin
        provider = Provider.create!(name: name, textkey: textkey)
        settings.each { |key, value| provider.settings.create(name: key, value: value.strip) }
      rescue ActiveRecord::RecordInvalid => e
        puts "Error #{e.message}"
        exit 1
      end
    end
  end
end
