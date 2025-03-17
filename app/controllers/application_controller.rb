class ApplicationController < ActionController::Base
  before_action :merge_session_cart, if: :user_signed_in?

  private

  def merge_session_cart
    return unless session[:cart]

    cart = current_user.cart || current_user.create_cart
    session[:cart].each do |product_id, quantity|
      cart_product = cart.cart_products.find_or_initialize_by(product_id: product_id)
      cart_product.quantity ||= 0 
      cart_product.quantity += quantity
      cart_product.save
    end

    session.delete(:cart) # Limpia el carrito de la sesión
  end
end