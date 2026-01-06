class VideosController < Public::BaseController
  def index
    @videos = Video.order(published_at: :desc)
    @pagy, @videos = pagy(@videos, items: 9)
    @categories = Category.all.order(:name)
  end
end

