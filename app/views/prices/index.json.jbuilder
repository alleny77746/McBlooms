json.array!(@prices) do |price|
  json.extract! price, :size_id, :amount, :name, :brief, :target
  json.url price_url(price, format: :json)
end
