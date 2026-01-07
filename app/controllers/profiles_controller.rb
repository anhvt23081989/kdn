class ProfilesController < ApplicationController
  layout "auth"
  
  before_action :authenticate_user!
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    if @user.update(profile_params)
      flash[:notice] = t('profiles.update_success', default: 'Thông tin cá nhân đã được cập nhật thành công.')
      redirect_to edit_profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def profile_params
    params.require(:user).permit(:name, :avatar)
  end
end

