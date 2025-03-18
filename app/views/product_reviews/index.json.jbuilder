# frozen_string_literal: true

json.array! @product_reviews, partial: 'product_reviews/product_review', as: :product_review
