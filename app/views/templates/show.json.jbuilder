# frozen_string_literal: true
json.extract! @template, :id, :name, :os, :tag_list, :script, :created_at, :updated_at
json.deployments template_deployments_url(@template, format: :json)
