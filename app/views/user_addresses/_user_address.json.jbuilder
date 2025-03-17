json.extract! user_address, :id, :user_id, :address_line1, :address_line2, :city, :state, :postal_code, :country, :created_at, :updated_at
json.url user_address_url(user_address, format: :json)
