class ApplicationController < ActionController::Base
  include Pagy::Method

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Make methods available to views
  # Note: current_admin_user is automatically provided by Devise when devise_for :admin_users is in routes
  helper_method :admin_user_signed_in?

  private

  # Check if admin user is signed in
  # current_admin_user is provided by Devise when devise_for :admin_users is in routes
  def admin_user_signed_in?
    return false unless respond_to?(:current_admin_user, true)
    begin
      current_admin_user.present?
    rescue NoMethodError, NameError
      false
    end
  end
end

