class LocalesController < ApplicationController
  def set_locale
    locale = params[:locale].to_sym
    if I18n.available_locales.include?(locale)
      I18n.locale = locale
      session[:locale] = locale
    end
    redirect_back(fallback_location: root_path)
  end
end

