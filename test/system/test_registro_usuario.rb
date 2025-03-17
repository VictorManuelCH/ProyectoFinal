require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
    setup do
        @role = Role.create!(name: "Customer")
        @user = User.create!(
          email: "user@example.com",
          username: "user1",
          encrypted_password: "password1",
          role: @role
        )
    end
    test "un usuario puede registrarse" do
        visit root_path  # Ir a la página principal

        click_on "Registrarse" # Clic en el botón de registro

        # Verificar que estamos en la página de registro
        assert_selector "h2", text: "Registro"

        # Completar el formulario de registro
        fill_in "Correo Electrónico", with: "usuario@example.com"
        fill_in "Contraseña", with: "password123"
        fill_in "Confirmar Contraseña", with: "password123"
        select "Cliente", from: "Seleccionar Rol" # Selecciona un rol en el dropdown
        click_on "Registrarse" # Enviar el formulario

        # Verificar que el registro fue exitoso
        assert_text "Bienvenido"  # Ajusta este mensaje según tu aplicación
        assert_current_path root_path  # Debe redirigir a la página principal
    end
end
