module ApplicationHelper
  # Pagy helper methods
  def pagy_nav(pagy)
    pagy.series_nav.html_safe
  end
end
