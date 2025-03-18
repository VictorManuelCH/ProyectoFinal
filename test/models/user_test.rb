require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    # Crear roles
    @role_admin = Role.create!(name: "Administrador")
    @role_customer = Role.create!(name: "Customer")

    # Crear usuarios
    @admin = User.create!(email: "admin@example.com", password: "password")
    @admin.roles << @role_admin

    @customer = User.create!(email: "customer@example.com", password: "password")
    @customer.roles << @role_customer

    # Crear productos
    @product_available = Product.create!(name: "Laptop", description: "Laptop potente", price: 1000.0, quantity: 10)
    @product_out_of_stock = Product.create!(name: "Tablet", description: "Tablet sin stock", price: 500.0, quantity: 0)
  end

  # 📌 Test para verificar que un usuario puede crearse
  test "puede crear un usuario" do
    user = User.new(email: "test@example.com", password: "password")
    assert user.save, "El usuario debería guardarse correctamente"
  end

  # 📌 Test para verificar que un usuario tiene un carrito después de crearse
  test "se crea un carrito automáticamente después de crear un usuario" do
    assert_not_nil @user.cart, "El usuario debería tener un carrito asociado automáticamente"
  end

  # 📌 Test: Un administrador puede ver los botones de agregar producto y categoría
  test "un administrador ve los botones de gestión" do
    login_as(@admin, scope: :user) # Devise helper para iniciar sesión
    visit root_path

    assert_selector "a", text: "Añadir Producto"
    assert_selector "a", text: "Añadir Categoría"
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

  # 📌 Test para verificar la relación con órdenes
  test "puede tener órdenes" do
    order = Order.create!(user: @user)
    assert_includes @user.orders, order, "El usuario debería tener órdenes asociadas"
  end

  # 📌 Test para verificar la relación con roles
  test "puede tener múltiples roles" do
    @user.roles << @role_admin
    @user.roles << @role_customer

    assert_includes @user.roles, @role_admin, "El usuario debería tener el rol de Administrador"
    assert_includes @user.roles, @role_customer, "El usuario debería tener el rol de Customer"
  end

  # 📌 Test para verificar si el usuario es administrador
  test "debería detectar si es administrador" do
    @user.roles << @role_admin
    assert @user.administrador?, "El usuario debería ser administrador"
  end

  # 📌 Test para verificar que un usuario sin rol de administrador no es administrador
  test "no debería ser administrador si no tiene el rol" do
    @user.roles << @role_customer
    assert_not @user.administrador?, "El usuario no debería ser administrador"
  end

  
end
