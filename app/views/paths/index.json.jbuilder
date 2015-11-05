json.array!(@paths) do |path|
  json.extract! path, :id, :structure
  json.url path_url(path, format: :json)
end
