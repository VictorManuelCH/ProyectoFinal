# frozen_string_literal: true

json.extract! order_item, :id, :order_id, :product_id, :quantity, :price, :created_at, :updated_at
json.url order_item_url(order_item, format: :json)
