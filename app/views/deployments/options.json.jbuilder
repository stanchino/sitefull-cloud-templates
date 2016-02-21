json.regions do
  json.array!(@decorator.regions_for_select) do |region|
    json.extract! region, :id, :name
  end
end
json.flavors do
  json.array!(@decorator.flavors_for_select) do |flavor|
    json.extract! flavor, :id, :name
  end
end
json.images do
  json.array!(@decorator.images_for_select) do |image|
    json.extract! image, :id, :name
  end
end
