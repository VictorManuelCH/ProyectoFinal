# frozen_string_literal: true

json.array! @product_categories, partial: 'product_categories/product_category', as: :product_category
