require "test_helper"
require "application_system_test_case"


class ProductDetailsTest < ApplicationSystemTestCase
    test "un usuario puede ver los detalles de un producto" do
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

      # Adjuntar una imagen ficticia si Active Storage está habilitado
      producto.images.attach(io: File.open(Rails.root.join("test/fixtures/files/test_image.jpg")),
                            filename: "test_image.jpg",
                            content_type: "image/jpg")
  
      # Visitar la página del producto
      visit product_path(producto)
  
      # Verificar que se muestra la información correcta
      assert_text "Laptop Gamer"
      assert_text "Una laptop potente para gaming"
      assert_text "$1,500.00"
    end
  end
