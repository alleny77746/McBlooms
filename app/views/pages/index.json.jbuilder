json.array!(@pages) do |page|
  json.extract! page, :title, :content, :start_on, :end_on
  json.url page_url(page, format: :json)
end
