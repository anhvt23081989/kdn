class CategoriesController < Public::BaseController
  def show
    @category = Category.find_by!(slug: params[:slug])
    @products = Product.published
                       .where(category: @category)
                       .order(created_at: :desc)
    @pagy, @products = pagy(@products, items: 12)
    @subcategories = @category.children.order(:position)
  end
end

