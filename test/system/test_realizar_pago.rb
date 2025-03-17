require "test_helper"
require "application_system_test_case"

class CheckoutTest < ApplicationSystemTestCase
  setup do
    @product = Product.create!(
      name: "Producto de prueba",
      description: "Descripción del producto",
      price: 100.0,
      quantity: 10
    )

    @user = User.create!(
      email: "cliente@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: Role.create!(name: "Cliente")
    )
  end

  test "un usuario puede proceder al pago desde el carrito" do
    # Iniciar sesión
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "password123"
    click_button "Iniciar sesión"

    # Visitar productos y agregar uno al carrito
    visit products_path
    assert_text "Producto de prueba"
    click_button "Añadir al Carrito"

    # Verificar que el producto esté en el carrito
    assert_text "Mi carrito"
    assert_text "Producto de prueba"

    # Hacer clic en "Proceder a Pagar"
    click_button "Proceder a Pagar"

    # Verificar que se redirige a la página de pago
    assert_current_path checkout_cart_path(@user.cart)
    assert_text "Gracias por tu compra!"
  end
end
