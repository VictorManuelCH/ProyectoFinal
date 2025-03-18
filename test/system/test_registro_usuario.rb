# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    User.destroy_all
    @role = Role.create!(name: 'Cliente')
  end

  test 'un usuario puede registrarse' do
    visit new_user_registration_path

    unique_email = "user_#{SecureRandom.hex(4)}@example.com" # Correo único en cada ejecución
    fill_in 'Correo Electrónico', with: unique_email
    fill_in 'Contraseña', with: 'password1'
    fill_in 'Confirmar Contraseña', with: 'password1'
    select 'Cliente', from: 'Seleccionar Rol'

    click_button 'Registrarse'

    assert_text 'BIENVENIDO A NUESTRA TIENDA'
  end
end
