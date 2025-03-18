require "application_system_test_case"

class HomeTest2 < ApplicationSystemTestCase
    # 📌 Test: Un administrador puede ver los botones de agregar producto y categoría
    test "un administrador ve los botones de gestión" do
        @role = Role.create!(name: "Administrador") # Asegúrate de que coincida exactamente con lo que hay en la BD
        @user = User.new(
        email: "test@example.com",
        password: "password1",
        password_confirmation: "password1"
        )
        @user.role_id = @role.id # ✅ Asignar manualmente antes de guardar
        @user.save! # Guardar el usuario con el role_id correctamente

    
        visit new_user_session_path
    
        fill_in "Correo electrónico", with: @user.email
        fill_in "Contraseña", with: "password1"
        click_button "Iniciar sesión"
    
        assert_text "Añadir Producto"
        assert_text "Añadir Categoría"
    end
end