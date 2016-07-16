# frozen_string_literal: true
json.items do
  json.array!(@items) do |item|
    json.extract! item, :id, :name
  end
end
