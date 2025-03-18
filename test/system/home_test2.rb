require "application_system_test_case"

class HomeTest2 < ApplicationSystemTestCase
    setup do
        User.destroy_all
        Role.destroy_all
        Product.destroy_all
      
        @role_admin = Role.find_or_create_by!(name: "Administrador")
        @role_customer = Role.find_or_create_by!(name: "Cliente")
      
        @admin = User.create!(
          email: "admin@example.com",
          password: "password1",
          password_confirmation: "password1"
        )
        @admin.roles << @role_admin # ✅ Asignar rol correctamente
      
        @customer = User.create!(
          email: "customer@example.com",
          password: "password1",
          password_confirmation: "password1"
        )
        @customer.roles << @role_customer # ✅ Asignar rol correctamente
      
        @product_available = Product.create!(name: "Laptop", price: 1000, quantity: 10)
        @product_out_of_stock = Product.create!(name: "Tablet", price: 500, quantity: 0)
    end
      
    test "un administrador ve los botones de gestión" do
        @role = Role.find_or_create_by!(name: "Administrador")
        @user = User.create!(
          email: "test@example.com",
          password: "password1",
          password_confirmation: "password1"
        )
        @user.roles << @role # ✅ Asignar rol correctamente
      
        # 🔍 Depuración en GitHub Actions
        puts "Roles en la BD: #{Role.pluck(:id, :name)}"
        puts "Roles del usuario creado: #{@user.roles.pluck(:id, :name)}"
      
        visit new_user_session_path
        fill_in "Correo electrónico", with: @user.email
        fill_in "Contraseña", with: "password1"
        click_button "Iniciar sesión"
      
        assert_text "Añadir Producto"
        assert_text "Añadir Categoría"
      end      
end