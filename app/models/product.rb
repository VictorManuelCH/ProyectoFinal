class Product < ApplicationRecord

  if Rails.env.production? || Rails.env.development?
    has_many_attached :images
  end
  
  has_many :cart_products
  has_many :carts, through: :cart_products
  has_many :order_items

  has_many :product_categories
  has_many :categories, through: :product_categories
  
  has_many :product_reviews
  has_many :product_images

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "price"] # Agrega los atributos que deseas permitir que Ransack busque
  end
end
