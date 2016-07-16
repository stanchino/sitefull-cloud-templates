# frozen_string_literal: true
json.array!(@deployments) do |deployment|
  json.extract! deployment, :id, :provider, :image, :machine_type
  json.url template_deployment_url(@template, deployment, format: :json)
end
