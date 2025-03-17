require "test_helper"
require "application_system_test_case"

class CartTest < ApplicationSystemTestCase
  setup do
    puts "Ejecutando setup..."

    # Crear categoría
    @category = Category.create!(name: "Electrónica")

    # Crear producto
    @product = Product.create!(
      name: "Laptop Gamer",
      description: "Una laptop potente para gaming",
      price: 1500.00,
      quantity: 10
    )

    # Asociar categoría al producto
    @product.categories << @category
    puts "Categorías del producto: #{@product.categories.pluck(:name)}"

    # Verificar que el producto existe en la BD
    puts "Productos en la BD: #{Product.count}"

    # Crear imagen de prueba
    file = Tempfile.new(["test_image", ".jpg"])
    file.binmode
    file.write("\xFF\xD8\xFF")
    file.rewind

    @product.images.attach(
      io: file,
      filename: "test_image.jpg",
      content_type: "image/jpeg"
    )

    file.close
    file.unlink

    # Crear usuario y rol
    User.destroy_all
    @role = Role.create!(name: "Cliente") 
    @user = User.create!(
      email: "test@example.com",
      password: "password1",
      password_confirmation: "password1",
      role_id: @role.id
    )

    puts "Setup ejecutado correctamente"
  end

  test "eliminar un producto del carrito" do
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "password1"
    click_button "Iniciar sesión"

    visit products_path
    assert_text "Laptop Gamer"

    click_button "Añadir al Carrito"

    assert_text "Mi carrito"
    assert_text "Laptop Gamer"

    click_button "Eliminar"

    refute_text "Laptop Gamer"
    assert_text "Tu carrito está vacío."
  end

  test "actualizar la cantidad de un producto en el carrito" do
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "password1"
    click_button "Iniciar sesión"

    visit products_path
    assert_text "Laptop Gamer"

    click_button "Añadir al Carrito"

    assert_text "Mi carrito"
    assert_text "Laptop Gamer"

    fill_in "quantity", with: 3
    click_button "Actualizar"

    assert_text "Cantidad: 3"
    assert_text "Total: $4500.00"
  end
end

