require "test_helper"
require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  setup do
    User.destroy_all
    Role.destroy_all # Elimina roles previos para evitar duplicados
    @role = Role.create!(name: "Cliente")

    # Crear un usuario con el rol asociado
    @user = User.create!(
      email: "test@example.com",
      password: "password1",
      password_confirmation: "password1",
      role: @role # Asegurar que el usuario tenga un rol válido
    )
  end

  test "un usuario puede iniciar sesión" do
    visit new_user_session_path # Ir a la página de inicio de sesión

    fill_in "Correo Electrónico", with: @user.email
    fill_in "Contraseña", with: "password1"
    click_button "Iniciar Sesión"

    assert_text "BIENVENIDO A NUESTRA TIENDA"
  end
end

