# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def new
      @roles = Role.all # Obtén todos los roles disponibles
      super # Llama al método new de Devise::RegistrationsController
    end

    def create
      build_resource(sign_up_params) # Asegúrate de usar los parámetros permitidos

      # Asignar el rol seleccionado al nuevo usuario
      if params[:user][:role_id].present?
        role = Role.find(params[:user][:role_id])
        resource.roles << role
      end

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role_id)
    end
  end
end
