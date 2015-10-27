json.array!(@users) do |user|
  json.extract! user, :id, :user_id, :points, :name
  json.url user_url(user, format: :json)
end
