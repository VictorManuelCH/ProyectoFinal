# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class ProductDetailsTest < ApplicationSystemTestCase
  test 'un usuario puede ver los detalles de un producto' do
    # Crear una categoría antes de crear el producto
    categoria = Category.create!(name: 'Electrónica')

    # Crear un producto con la categoría asociada
    producto = Product.create!(
      name: 'Laptop Gamer',
      description: 'Una laptop potente para gaming',
      price: 1500.00,
      quantity: 10
    )

    # Relacionar el producto con la categoría
    producto.categories << categoria

    # Crear un archivo temporal para la imagen
    file = Tempfile.new(['test_image', '.jpg'])
    file.binmode
    file.write("\xFF\xD8\xFF") # Encabezado mínimo para que sea un archivo JPG válido
    file.rewind

    # Adjuntar la imagen temporal al producto
    producto.images.attach(
      io: file,
      filename: 'test_image.jpg',
      content_type: 'image/jpeg'
    )

    file.close
    file.unlink # Eliminar el archivo temporal después de adjuntarlo

    # Visitar la página del producto
    visit product_path(producto)

    # Verificar que se muestra la información correcta
    assert_text 'Laptop Gamer'
    assert_text 'Una laptop potente para gaming'
    assert_text '$1500.0'
  end
end
