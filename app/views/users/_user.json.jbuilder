json.extract! user, :id, :email, :username, :encrypted_password, :role_id, :created_at, :updated_at
json.url user_url(user, format: :json)
