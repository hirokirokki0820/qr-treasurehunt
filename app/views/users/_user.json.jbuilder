json.extract! user, :id, :name, :password_digest, :remember_digest, :created_at, :updated_at
json.url user_url(user, format: :json)
