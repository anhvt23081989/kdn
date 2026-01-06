class CataloguesController < Public::BaseController
  def index
    @catalogues = Catalogue.order(year: :desc, created_at: :desc)
    @pagy, @catalogues = pagy(@catalogues, items: 9)
  end
end

