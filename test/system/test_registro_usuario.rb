require "test_helper"
require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
    setup do
        @role = Role.create!(name: "Customer")
        @user = User.create!(
          email: "user@example.com",
          username: "user1",
          password: "password1",
          password_confirmation: "password1",
          role_id: @role.id # <- Agrega esto
        )
    end
      

    test "un usuario puede registrarse" do
        visit new_user_registration_path
        fill_in "Email", with: @user.email
        fill_in "Contraseña", with: "password1"
        fill_in "Confirmación de contraseña", with: "password1"
        click_button "Registrarse"

        assert_text "Bienvenido"
    end
end
