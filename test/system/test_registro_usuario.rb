require "test_helper"

class UsersTest < ActionDispatch::SystemTestCase
  setup do
    @role = Role.create!(name: "Customer")
    @user = User.create!(
      email: "user@example.com",
      username: "user1",
      encrypted_password: "password1"
    )
    UserRole.create!(user: @user, role: @role) # 🔥 Asigna el rol correctamente
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

