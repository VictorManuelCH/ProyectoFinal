require "test_helper"
require "application_system_test_case"

class ProductDetailsTest < ApplicationSystemTestCase
  setup do
    @product = Product.create!(
      name: "Producto de prueba",
      description: "Descripción del producto",
      price: 100.0,
      quantity: 10
    )
  end

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
