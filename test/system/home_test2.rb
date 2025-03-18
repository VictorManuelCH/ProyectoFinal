require "application_system_test_case"

class HomeTest2 < ApplicationSystemTestCase
    # 📌 Test: Un administrador puede ver los botones de agregar producto y categoría
    test "un administrador ve los botones de gestión" do
        # ✅ Asegurar que el rol de Administrador existe
        @role = Role.find_or_create_by!(name: "Administrador")
    
        # ✅ Crear usuario con el rol correcto
        @user = User.create!(
          email: "test@example.com",
          password: "password1",
          password_confirmation: "password1",
          role_id: @role.id # Si tienes `belongs_to :role`
        )
    
        # ✅ Verificar que el usuario tiene el rol correcto
        assert_equal "Administrador", @user.role.name
    
        # 🔹 Iniciar sesión con Capybara
        visit new_user_session_path
    
        fill_in "Correo electrónico", with: @user.email
        fill_in "Contraseña", with: "password1"
        click_button "Iniciar sesión"
    
        # ✅ Verificar que la sesión se inició correctamente
        assert_text "Cerrar Sesión"
    
        # ✅ Verificar que los botones están visibles
        assert_selector "a", text: "Añadir Producto"
        assert_selector "a", text: "Añadir Categoría"
      end
end