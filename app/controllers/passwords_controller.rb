class PasswordsController < ApplicationController
  layout "auth"
  
  before_action :authenticate_user!
  
  def edit
    @user = current_user
    @minimum_password_length = Devise.password_length.min
  end
  
  def update
    @user = current_user
    
    # Use Devise's update_with_password method which validates current_password
    if @user.update_with_password(password_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      flash[:notice] = t('profiles.password_update_success', default: 'Mật khẩu đã được thay đổi thành công.')
      redirect_to change_password_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end

