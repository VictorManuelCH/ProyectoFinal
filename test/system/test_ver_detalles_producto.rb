require "test_helper"
require "application_system_test_case"

class ProductDetailsTest < ApplicationSystemTestCase
  # 🛒 Crear una categoría si es necesaria
  categoria = Category.create!(name: "Electrónica")

  # 📦 Crear un producto con categoría
  producto = Product.create!(
    name: "Laptop Gamer",
    description: "Una laptop potente para gaming",
    price: 1500.00,
    quantity: 10,
    categories: [categoria]  # Asegura que tenga categorías asociadas
  )

  test "un usuario puede ver los detalles de un producto" do
    visit products_path

    assert_text "Producto de prueba"
    click_link "Ver Detalles"

    assert_current_path product_path(@product)
    assert_text "Producto de prueba"
    assert_text "Descripción del producto"
    assert_text "$100.00"
  end
end
