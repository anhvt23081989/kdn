class PostsController < Public::BaseController
  def index
    @posts = Post.published.order(published_at: :desc)
    @pagy, @posts = pagy(@posts, items: 9)
    @categories = Category.all.order(:name)
  end

  def show
    @post = Post.published.find_by!(slug: params[:slug])
    @related_posts = Post.published
                         .where(category: @post.category)
                         .where.not(id: @post.id)
                         .limit(4)
  end
end

