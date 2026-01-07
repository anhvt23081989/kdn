class ApplicationController < ActionController::Base
  include Pagy::Method

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # I18n locale handling
  before_action :set_locale

  # Make methods available to views
  # Note: current_admin_user is automatically provided by Devise when devise_for :admin_users is in routes
  helper_method :admin_user_signed_in?, :current_locale, :user_admin?, :user_guest?, :user_display_name

  private

  def set_locale
    if params[:locale].present?
      locale = params[:locale].to_sym
      if I18n.available_locales.include?(locale)
        I18n.locale = locale
        session[:locale] = locale
      else
        I18n.locale = session[:locale] || I18n.default_locale
      end
    else
      I18n.locale = session[:locale] || I18n.default_locale
    end
  end

  def current_locale
    I18n.locale
  end

  # Check if current user is admin
  def user_admin?
    user_signed_in? && current_user.admin?
  end

  # Check if current user is guest
  def user_guest?
    user_signed_in? && current_user.guest?
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge(options)
  end

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

  # Helper method to display user name or email
  def user_display_name(user)
    return nil unless user
    user.name.presence || user.email
  end
end

