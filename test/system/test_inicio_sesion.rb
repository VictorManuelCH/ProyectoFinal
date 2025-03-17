require "test_helper"
require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  setup do
    User.destroy_all
    @role = Role.create!(name: "Cliente")

    @user = User.create!(
      email: "test_user@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: @role
    )
  end

  test "un usuario puede iniciar sesión" do
    visit new_user_session_path

    fill_in "Correo electrónico", with: @user.email  
    fill_in "Contraseña", with: "password123"
    click_button "Iniciar sesión"  

    assert_text "BIENVENIDO A NUESTRA TIENDA"
  end
end
