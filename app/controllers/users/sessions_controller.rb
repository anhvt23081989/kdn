class Users::SessionsController < Devise::SessionsController
  layout "auth"
  
  # Override create to check confirmation before signing in
  def create
    self.resource = warden.authenticate!(auth_options)
    
    # Check if user is confirmed
    unless resource.confirmed?
      set_flash_message!(:alert, :unconfirmed)
      # Store email for resend confirmation link
      flash[:email] = resource.email
      redirect_to new_user_session_path and return
    end
    
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  rescue Warden::NotAuthenticated => e
    # Authentication failed - let Devise handle it
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource)
  end
  
  # Override destroy to add custom logout message
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message!(:notice, :signed_out) if signed_out
    yield if block_given?
    respond_to_on_destroy
  end
end

