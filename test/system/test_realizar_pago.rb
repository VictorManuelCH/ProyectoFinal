require "test_helper"
require "application_system_test_case"

class CheckoutTest < ApplicationSystemTestCase
  setup do
    User.destroy_all
    @role = Role.create!(name: "Cliente") # Crear rol
    @user = User.create!(
      email: "test@example.com",
      password: "password1",
      password_confirmation: "password1",
      role_id: @role.id # Asignar el rol correctamente
    )
  end

  test "un usuario puede proceder al pago desde el carrito" do
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

    # Iniciar sesión
    visit new_user_session_path
    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "password123"
    click_button "Iniciar sesión"

    # Visitar productos y agregar uno al carrito
    visit product_path(producto)
    assert_text "Laptop Gamer"
    click_button "Añadir al Carrito"

    # Verificar que el producto esté en el carrito
    assert_text "Mi carrito"
    assert_text "Laptop Gamer"

    # Hacer clic en "Proceder a Pagar"
    click_button "Proceder a Pagar"

    puts current_url

    # Verificar que se redirige a la página de pago
    assert_current_path payment_confirmation_cart_path
    assert_text "Gracias por tu compra!"
  end
end
