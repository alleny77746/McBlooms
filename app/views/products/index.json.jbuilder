json.array!(@products) do |product|
  json.extract! product, :sku, :name, :description, :start_date, :end_date
  json.url product_url(product, format: :json)
end
