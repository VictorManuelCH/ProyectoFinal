# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class LoginTest < ApplicationSystemTestCase
  setup do
    User.destroy_all
    @role = Role.create!(name: 'Cliente') # Crear rol
    @user = User.create!(
      email: 'test@example.com',
      password: 'password1',
      password_confirmation: 'password1',
      role_id: @role.id # Asignar el rol correctamente
    )
  end

  test 'un usuario puede iniciar sesión' do
    visit new_user_session_path

    fill_in 'Correo electrónico', with: @user.email
    fill_in 'Contraseña', with: 'password1'

    click_button 'Iniciar sesión'

    assert_text 'BIENVENIDO A NUESTRA TIENDA'
  end
end
