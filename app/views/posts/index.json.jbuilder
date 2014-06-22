json.array!(@posts) do |post|
  json.extract! post, :id, :all, :rank, :constellation, :result, :lucky, :advice, :created_at
  json.url post_url(post, format: :json)
end
