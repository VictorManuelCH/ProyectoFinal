require "test_helper"
require "application_system_test_case"

class AddToCartTest < ApplicationSystemTestCase
  setup do
    # Crear una categoría antes de crear el producto
    categoria = Category.create!(name: "Electrónica")

    # Crear un producto con la categoría asociada
    producto = Product.create!(
      name: "Laptop Gamer",
      description: "Una laptop potente para gaming",
      price: 1500.00,
      quantity: 10
    )

    # Relacionar el producto con la categoría
    producto.categories << categoria

    # Crear un archivo temporal para la imagen
    file = Tempfile.new(["test_image", ".jpg"])
    file.binmode
    file.write("\xFF\xD8\xFF") # Encabezado mínimo para que sea un archivo JPG válido
    file.rewind

    # Adjuntar la imagen temporal al producto
    producto.images.attach(
      io: file,
      filename: "test_image.jpg",
      content_type: "image/jpeg"
    )

    file.close
    file.unlink # Eliminar el archivo temporal después de adjuntarlo

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
