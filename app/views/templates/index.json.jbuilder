json.array!(@templates) do |template|
  json.extract! template, :id, :name, :os, :tag_list
  json.url template_url(template, format: :json)
end
