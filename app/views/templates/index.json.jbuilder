json.array!(@templates) do |template|
  json.extract! template, :id, :name, :script
  json.url template_url(template, format: :json)
end
