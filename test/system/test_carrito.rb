require "test_helper"
require "application_system_test_case"

class CartTest < ApplicationSystemTestCase
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

    User.destroy_all
    @role = Role.create!(name: "Cliente") # Crear rol
    @user = User.create!(
      email: "test@example.com",
      password: "password1",
      password_confirmation: "password1",
      role_id: @role.id # Asignar el rol correctamente
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
