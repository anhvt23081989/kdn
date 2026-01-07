class SystemSettingsController < ApplicationController
  layout "admin"
  
  before_action :authenticate_user!
  before_action :authorize_admin!

  def menu
    # This action will display the system settings menu
    # Add any data needed for the settings page here
  end

  private

  def authorize_admin!
    unless current_user&.admin?
      flash[:alert] = t('system_settings.unauthorized', default: 'Bạn không có quyền truy cập trang này.')
      redirect_to root_path
    end
  end
end

