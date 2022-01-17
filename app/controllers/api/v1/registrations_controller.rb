# frozen_string_literal: true

class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :configure_account_update_params, only: [:update]

  # PATCH /resource
  # def update
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params    
    devise_parameter_sanitizer.permit(:account_update, keys: [{ pictures: [] }])
  end
end
