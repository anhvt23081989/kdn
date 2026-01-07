class Users::RegistrationsController < Devise::RegistrationsController
  layout "auth"
  
  def create
    super do |resource|
      if resource.persisted? && resource.errors.empty?
        # User created successfully, confirmation email will be sent automatically
        # by Devise confirmable module
        set_flash_message!(:notice, :signed_up_but_unconfirmed)
      elsif resource.errors.any?
        # Log errors for debugging
        Rails.logger.error "Registration errors: #{resource.errors.full_messages.join(', ')}"
      end
    end
  rescue => e
    # Catch any errors during registration (e.g., email sending errors)
    Rails.logger.error "Registration error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    flash[:alert] = t('auth.registration_error', default: 'Có lỗi xảy ra khi đăng ký. Vui lòng thử lại.')
    redirect_to new_user_registration_path
  end
  
  protected
  
  def after_sign_up_path_for(resource)
    # Redirect to confirmation instructions page
    confirmation_instructions_path(email: resource.email)
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :name])
  end
end

