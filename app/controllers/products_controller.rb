class ProductsController < Public::BaseController
  before_action :set_product, only: [:show]

  def index
    @category = Category.find_by(slug: params[:category_slug]) if params[:category_slug].present?
    @category = Category.find_by(id: params[:category_id]) if params[:category_id].present? && !@category
    
    @products = Product.published.includes(:category)
    @products = @products.where(category: @category) if @category
    @products = @products.order(created_at: :desc)
    
    respond_to do |format|
      format.html do
        @pagy, @products = pagy(@products, items: 12)
        @categories = Category.where(parent_id: nil).order(:position)
      end
      format.json do
        @products = @products.limit(8)
        render json: {
          products: @products.map do |product|
            {
              id: product.id,
              name: product.name,
              slug: product.slug,
              sku: product.sku,
              image_url: product.images.attached? ? url_for(product.images.first) : nil
            }
          end
        }
      end
    end
  end

  def show
    @related_products = Product.published
                               .where(category: @product.category)
                               .where.not(id: @product.id)
                               .limit(4)
  end

  private

  def set_product
    @product = Product.published.find_by!(slug: params[:slug])
  end
end

