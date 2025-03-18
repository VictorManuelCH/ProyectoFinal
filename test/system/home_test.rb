require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase

  include Warden::Test::Helpers

  
  setup do
    User.destroy_all
    Role.destroy_all
    Product.destroy_all

    @role_admin = Role.create!(name: "Administrador")
    @role_customer = Role.create!(name: "Cliente")

    @admin = User.create!(
      email: "admin@example.com",
      password: "password1",
      password_confirmation: "password1",
      role_id: @role_admin.id
    )

    @customer = User.create!(
      email: "customer@example.com",
      password: "password1",
      password_confirmation: "password1",
      role_id: @role_customer.id
    )

    @product_available = Product.create!(name: "Laptop", price: 1000, quantity: 10)
    @product_out_of_stock = Product.create!(name: "Tablet", price: 500, quantity: 0)

  end

  # 📌 Test: La página principal carga correctamente
  test "la página principal se muestra correctamente" do
    visit root_path

    assert_text "BIENVENIDO A NUESTRA TIENDA"
    assert_text "Productos"
    assert_text "Categorías"
    assert_text @product_available.name # Asegura que se ve un producto disponible
  end

  # 📌 Test: Un administrador puede ver los botones de agregar producto y categoría
  test "un administrador ve los botones de gestión" do
    User.destroy_all
    @role = Role.create!(name: "administrador") # Crear rol
    @user = User.create!(
      email: "test@example.com",
      password: "password1",
      password_confirmation: "password1",
      role_id: @role.id # Asignar el rol correctamente
    )
  
    visit new_user_session_path
  
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "password1"
    click_button "Iniciar sesión"
  
    assert_text "Añadir Producto"
    assert_text "Añadir Categoría"
  end
  

  # 📌 Test: Un cliente no puede ver los botones de agregar producto
  test "un cliente no ve los botones de gestión" do
    login_as(@customer, scope: :user)
    visit root_path

    assert_no_selector "a", text: "Añadir Producto"
    assert_no_selector "a", text: "Añadir Categoría"
  end

  # 📌 Test: Un usuario puede buscar productos con el formulario
  test "el usuario puede buscar productos" do
    visit root_path
    fill_in "Buscar productos", with: "Laptop"
    click_on "Buscar"

    assert_text "Laptop"
    assert_no_text "Tablet"
  end

  # 📌 Test: Un producto agotado muestra el mensaje correspondiente
  test "producto agotado muestra mensaje y no permite añadir al carrito" do
    visit root_path

    within(".card", text: @product_out_of_stock.name) do
      assert_text "Producto Agotado"
      assert_no_selector "button", text: "Añadir al Carrito"
    end
  end

  # 📌 Test para validar la búsqueda con Ransack
  test "ransack permite buscar por nombre, descripción y precio" do
    allowed_attributes = Product.ransackable_attributes
    assert_includes allowed_attributes, "name"
    assert_includes allowed_attributes, "description"
    assert_includes allowed_attributes, "price"
    assert_not_includes allowed_attributes, "created_at", "Ransack no debería permitir búsqueda por created_at"
  end
end

