require "test_helper"
require "application_system_test_case"

class AddToCartTest < ApplicationSystemTestCase
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

  test "un usuario puede añadir un producto al carrito" do
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "password123"
    click_button "Iniciar sesión"

    visit products_path

    assert_text "Producto de prueba"
    click_button "Añadir al Carrito"

    assert_text "Mi carrito"
    assert_text "Producto de prueba"
  end
end
