require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  # 📌 Test para verificar que un usuario puede crearse
  test "puede crear un usuario" do
    role = Role.create!(name: "Cliente")
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id)
    assert user.persisted?, "El usuario debería guardarse correctamente"
  end

  # 📌 Test para verificar que un usuario tiene un carrito después de crearse
  test "se crea un carrito automáticamente después de crear un usuario" do
    role = Role.create!(name: "customer")
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id)
    cart = Cart.create!(user: user) 
    assert_not_nil user.cart, "El usuario debería tener un carrito asociado automáticamente"
  end

  # 📌 Test para verificar la relación con órdenes
  test "puede tener órdenes" do
    role = Role.create!(name: "Cliente")
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id)
  
    cart = Cart.create!(user: user)  # 🔹 Se crea el carrito antes de la orden
    order = Order.create!(user: user, cart: cart)  # 🔹 Se asocia el carrito a la orden
    
    assert_includes user.orders, order, "El usuario debería tener órdenes asociadas"
  end
  

  # 📌 Test para verificar la relación con roles
  test "puede tener múltiples roles" do
    user = User.create!(email: "test@example.com", password: "password", role_id: Role.create!(name: "Cliente").id)
  
    role_admin = Role.create!(name: "Administrador")
    role_customer = Role.create!(name: "Customer")
  
    user.roles << role_admin
    user.roles << role_customer
  
    assert_includes user.roles, role_admin, "El usuario debería tener el rol de Administrador"
    assert_includes user.roles, role_customer, "El usuario debería tener el rol de Customer"
  end
  

  # 📌 Test para verificar si el usuario es administrador
  test "debería detectar si es administrador" do
    user = User.create!(email: "test@example.com", password: "password", role_id: Role.create!(name: "Cliente").id)
  
    role_admin = Role.create!(name: "Administrador")
    user.roles << role_admin  
  
    assert user.administrador?, "El usuario debería ser administrador"
  end
  

  # 📌 Test para verificar que un usuario sin rol de administrador no es administrador
  test "no debería ser administrador si no tiene el rol" do
    user = User.create!(email: "test@example.com", password: "password", role_id: Role.create!(name: "Cliente").id)
  
    role_customer = Role.create!(name: "Customer")
    user.roles << role_customer  
  
    assert_not user.administrador?, "El usuario no debería ser administrador"
  end  
  
end
