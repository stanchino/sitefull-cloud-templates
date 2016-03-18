json.items do
  json.array!(@items) do |item|
    json.extract! item, :id, :name
  end
end
