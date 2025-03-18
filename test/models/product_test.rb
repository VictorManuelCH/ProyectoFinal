require "test_helper"
require "stringio"

class ProductTest < ActiveSupport::TestCase
  
  def setup
    @product = Product.new(name: "Laptop", description: "Una laptop potente", price: 1500.0)
  end

  # 📌 Test para crear un producto (Create)
  test "puede crear un producto" do
    product = Product.new(name: "Smartphone", description: "Teléfono inteligente", price: 500.0)
    assert product.save, "El producto debería guardarse correctamente"
  end

  # 📌 Test para leer un producto (Read)
  test "puede leer un producto" do
    product = Product.create!(name: "Laptop", description: "Una laptop potente", price: 1500.0)

    encontrado = Product.find_by(id: product.id)
    assert_equal product, encontrado, "El producto debería encontrarse correctamente"
  end


  # 📌 Test para actualizar un producto (Update)
  test "puede actualizar un producto" do
    nuevo_nombre = "Laptop Gaming"
    @product.update(name: nuevo_nombre)
    assert_equal nuevo_nombre, @product.reload.name, "El nombre del producto debería actualizarse correctamente"
  end

  # 📌 Test para eliminar un producto (Delete)
  test "puede eliminar un producto" do
    product_id = @product.id
    @product.destroy
    assert_not Product.exists?(product_id), "El producto debería eliminarse correctamente"
  end

  # 📌 Test para validar la creación de un producto válido
  test "puede crear un producto válido" do
    assert @product.save, "El producto debería guardarse correctamente"
  end

  # 📌 Test para validar la presencia del nombre
  test "debe ser inválido sin nombre" do
    @product.name = nil
    assert_not @product.valid?, "El producto no debería ser válido sin un nombre"
    assert_includes @product.errors[:name], "can't be blank"
  end

  # 📌 Test para verificar la asociación con categorías
  test "puede tener múltiples categorías" do
    product = Product.create!(name: "Smartphone", description: "Teléfono inteligente", price: 500.0)
    category1 = Category.create!(name: "Electrónica")
    category2 = Category.create!(name: "Móviles")

    product.categories << [category1, category2]

    assert_equal 2, product.categories.count, "El producto debería tener dos categorías"
    assert_includes product.categories, category1
    assert_includes product.categories, category2
  end

  # 📌 Test para verificar la asociación con imágenes
  test "puede tener imágenes adjuntas" do
    image_data = StringIO.new("\xFF\xD8\xFF\xE0" + ("0" * 100)) # Simula un JPG
    product = Product.create!(name: "Cámara", description: "Cámara profesional", price: 1000.0)

    product.images.attach(io: image_data, filename: "test.jpg", content_type: "image/jpeg")

    assert product.images.attached?, "El producto debería tener imágenes adjuntas"
  end

end
