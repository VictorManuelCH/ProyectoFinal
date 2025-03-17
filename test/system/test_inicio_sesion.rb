require "test_helper"
require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  setup do
    User.destroy_all
    @user = User.create!(
      email: "test@example.com",
      password: "password1",
      password_confirmation: "password1",
      role: "Cliente" # Asegúrate de que `role` es un atributo válido
    )
  end

  test "un usuario puede iniciar sesión" do
    visit new_user_session_path

    fill_in "Correo electrónico", with: @user.email
    fill_in "Contraseña", with: "password1"
    
    click_button "Iniciar sesión"

    assert_text "BIENVENIDO A NUESTRA TIENDA"
  end
end


