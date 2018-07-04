json.extract! user, :id, :name, :screen_name, :icon, :email, :posts_count, :created_at, :updated_at
json.url user_url(user, format: :json)
