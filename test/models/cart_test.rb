require "test_helper"

class CartTest < ActiveSupport::TestCase
  # Test para crear un carrito
  test "puede crear un carrito" do
    role = Role.create!(name: "customer") # Si tienes un modelo Role
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id) # Asigna un role_id
    cart = Cart.create!(user: user)
    cart = Cart.new
    assert cart.save, "El carrito debería guardarse correctamente"
  end

  # Test para leer un carrito
  test "puede encontrar un carrito" do
    role = Role.create!(name: "customer") # Si tienes un modelo Role
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id) # Asigna un role_id
    cart = Cart.create!(user: user)
    encontrado = Cart.find_by(id: cart.id)
    assert_equal cart, encontrado, "El carrito debería encontrarse correctamente"
  end

  # Test para actualizar un carrito
  test "puede actualizar un carrito" do
    role = Role.create!(name: "customer") # Si tienes un modelo Role
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id) # Asigna un role_id
    cart = Cart.create!(user: user)
    cart.update(user_id: 1)  # Simulamos que el carrito pertenece a un usuario
    assert_equal 1, cart.user_id, "El user_id del carrito debería actualizarse correctamente"
  end

  # Test para eliminar un carrito
  test "puede eliminar un carrito" do
    role = Role.create!(name: "customer") # Si tienes un modelo Role
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id) # Asigna un role_id
    cart = Cart.create!(user: user)
    cart_id = cart.id
    cart.destroy
    assert_not Cart.exists?(cart_id), "El carrito debería eliminarse correctamente"
  end

  # Test para verificar que un carrito vacío tiene total 0
  test "debe devolver total 0 si el carrito está vacío" do
    role = Role.create!(name: "customer") # Si tienes un modelo Role
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id) # Asigna un role_id
    cart = Cart.create!(user: user)
    assert_equal 0, cart.total_price, "El total de un carrito vacío debe ser 0"
  end

  # Test para asegurarse de que un carrito puede tener productos
  test "puede contener productos" do
    role = Role.create!(name: "customer") # Si tienes un modelo Role
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id) # Asigna un role_id
    cart = Cart.create!(user: user)e
    product = Product.create(name: "Producto", price: 20.0, quantity: 10)

    cart_product = CartProduct.create(cart: cart, product: product, quantity: 1)

    assert_includes cart.products, product, "El carrito debe contener el producto añadido"
  end

  # Test para verificar que la cantidad del producto en el carrito es la correcta
  test "cantidad del producto en el carrito es correcta" do
    role = Role.create!(name: "customer") # Si tienes un modelo Role
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id) # Asigna un role_id
    cart = Cart.create!(user: user)
    product = Product.create(name: "Producto", price: 50.0, quantity: 10)

    cart_product = CartProduct.create(cart: cart, product: product, quantity: 3)

    assert_equal 3, cart.cart_products.find_by(product: product).quantity, "La cantidad en el carrito debe ser 3"
  end

  # Test para verificar la eliminación de productos en el carrito
  test "debe eliminar productos cuando se elimina el carrito" do
    role = Role.create!(name: "customer") # Si tienes un modelo Role
    user = User.create!(email: "test@example.com", password: "password", role_id: role.id) # Asigna un role_id
    cart = Cart.create!(user: user)
    product = Product.create(name: "Producto", price: 30.0, quantity: 5)

    cart_product = CartProduct.create(cart: cart, product: product, quantity: 2)
    cart.destroy

    assert_not CartProduct.exists?(cart_product.id), "Los productos en el carrito deben eliminarse junto con el carrito"
  end
end
