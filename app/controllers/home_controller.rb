class HomeController < Public::BaseController
  def index
    @featured_products = Product.published.limit(8)
    @latest_posts = Post.published.order(published_at: :desc).limit(6)
    @categories = Category.where(parent_id: nil).order(:position)
    
    # Category blocks with subcategories for tabs
    # Try to find by exact slug first, then by partial match
    @bon_cau_category = Category.find_by(slug: "bon-cau") || 
                        Category.where("slug LIKE ?", "%bon-cau%").first ||
                        Category.where("name ILIKE ?", "%bồn cầu%").first
    @lavabo_category = Category.find_by(slug: "lavabo") || 
                       Category.where("slug LIKE ?", "%lavabo%").first ||
                       Category.where("name ILIKE ?", "%lavabo%").first
    @sen_voi_category = Category.find_by(slug: "sen-voi") || 
                        Category.where("slug LIKE ?", "%sen%").first ||
                        Category.where("name ILIKE ?", "%sen%").first
    @phu_kien_category = Category.find_by(slug: "phu-kien") || 
                         Category.where("slug LIKE ?", "%phu-kien%").first ||
                         Category.where("name ILIKE ?", "%phụ kiện%").first
    
    # Get subcategories for each main category
    @bon_cau_subcategories = @bon_cau_category&.children&.order(:position) || []
    @lavabo_subcategories = @lavabo_category&.children&.order(:position) || []
    @sen_voi_subcategories = @sen_voi_category&.children&.order(:position) || []
    @phu_kien_subcategories = @phu_kien_category&.children&.order(:position) || []
    
    # Get products for each category (first subcategory or main category)
    @bon_cau_products = get_category_products(@bon_cau_category, @bon_cau_subcategories.first)
    @lavabo_products = get_category_products(@lavabo_category, @lavabo_subcategories.first)
    @sen_voi_products = get_category_products(@sen_voi_category, @sen_voi_subcategories.first)
    @phu_kien_products = get_category_products(@phu_kien_category, @phu_kien_subcategories.first)
  end

  private

  def get_category_products(main_category, subcategory)
    category = subcategory || main_category
    return Product.none unless category
    
    Product.published
           .where(category: category)
           .order(created_at: :desc)
           .limit(8)
  end
end

