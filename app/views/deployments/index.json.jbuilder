json.array!(@deployments) do |deployment|
  json.extract! deployment, :id, :provider, :credentials, :image, :flavor
  json.url deployment_url(deployment, format: :json)
end
