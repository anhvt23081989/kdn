class LocalesController < ApplicationController
  skip_before_action :set_locale
  
  def set_locale
    new_locale = params[:locale].to_sym
    if I18n.available_locales.include?(new_locale)
      I18n.locale = new_locale
      session[:locale] = new_locale
      
      # Redirect to the same page but with new locale
      referer = request.referer
      if referer.present? && referer.start_with?(request.base_url)
        begin
          uri = URI.parse(referer)
          path = uri.path
          
          # Remove old locale from path if exists
          path = path.gsub(/^\/(vi|en)(\/|$)/, '/')
          path = '/' if path.blank? || path == '/'
          
          # Remove leading slash if not root
          path = path[1..-1] if path != '/' && path.start_with?('/')
          
          # Build new path with locale
          if path == '/' || path.blank?
            new_path = "/#{new_locale}"
          else
            new_path = "/#{new_locale}/#{path}"
          end
          
          # Preserve query string if exists
          new_path += "?#{uri.query}" if uri.query.present?
          
          redirect_to new_path, allow_other_host: false
        rescue URI::InvalidURIError, URI::BadURIError
          redirect_to "/#{new_locale}"
        end
      else
        redirect_to "/#{new_locale}"
      end
    else
      redirect_back(fallback_location: "/#{I18n.default_locale}", allow_other_host: false)
    end
  end
end

