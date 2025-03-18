# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :images

  has_many :cart_products
  has_many :carts, through: :cart_products
  has_many :order_items

  has_many :product_categories
  has_many :categories, through: :product_categories

  has_many :product_reviews
  has_many :product_images

  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name description price] # Agrega los atributos que deseas permitir que Ransack busque
  end
end
