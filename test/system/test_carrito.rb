require "test_helper"
require "application_system_test_case"

class CartTest < ApplicationSystemTestCase
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

  test "eliminar un producto del carrito" do
    # Iniciar sesión
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "password123"
    click_button "Iniciar sesión"

    # Agregar producto al carrito
    visit products_path
    assert_text "Producto de prueba"
    click_button "Añadir al Carrito"

    # Verificar que está en el carrito
    assert_text "Mi carrito"
    assert_text "Producto de prueba"

    # Eliminar producto
    click_button "Eliminar"

    # Verificar que se eliminó correctamente
    refute_text "Producto de prueba"
    assert_text "Tu carrito está vacío."
  end

  test "actualizar la cantidad de un producto en el carrito" do
    # Iniciar sesión
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "password123"
    click_button "Iniciar sesión"

    # Agregar producto al carrito
    visit products_path
    assert_text "Producto de prueba"
    click_button "Añadir al Carrito"

    # Verificar que está en el carrito
    assert_text "Mi carrito"
    assert_text "Producto de prueba"

    # Actualizar cantidad
    fill_in "quantity", with: 3
    click_button "Actualizar"

    # Verificar que se actualizó correctamente
    assert_text "Cantidad: 3"
    assert_text "Total: $300.00"
  end
end
