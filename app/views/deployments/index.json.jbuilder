json.array!(@deployments) do |deployment|
  json.extract! deployment, :id, :provider, :image, :flavor
  json.url template_deployment_url(@template, deployment, format: :json)
end
