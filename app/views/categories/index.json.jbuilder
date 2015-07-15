json.array!(@categories) do |category|
  json.extract! category, :name, :description, :start_date, :end_date, :position
  json.url category_url(category, format: :json)
end
