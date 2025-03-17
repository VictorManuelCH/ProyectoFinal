class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products
  has_one :order

  # Asegurarse de que un pedido se cree automáticamente cuando el carrito se crea
  after_create :create_order_if_needed

  def total_price
    cart_products.sum { |cart_product| cart_product.product.price * cart_product.quantity }
  end

  private

  def create_order_if_needed
    # Si el carrito no tiene un pedido asociado, crear uno
    if order.nil?
      create_order!(user: user, total_price: total_price)
    end
  end
end
