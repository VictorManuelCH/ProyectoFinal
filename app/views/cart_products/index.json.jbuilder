# frozen_string_literal: true

json.array! @cart_products, partial: 'cart_products/cart_product', as: :cart_product
