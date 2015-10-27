json.array!(@user_rankings) do |user_ranking|
  json.extract! user_ranking, :id, :user_id, :path, :points
  json.url user_ranking_url(user_ranking, format: :json)
end
