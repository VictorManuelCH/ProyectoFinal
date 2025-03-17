json.extract! product_image, :id, :product_id, :image_url, :created_at, :updated_at
json.url product_image_url(product_image, format: :json)
