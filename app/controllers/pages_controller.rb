class PagesController < Public::BaseController
  def show
    # This would typically fetch a Page model, but for now we'll handle static pages
    @slug = params[:slug]
    
    # You can add logic here to fetch from a Page model if you create one
    # @page = Page.find_by!(slug: @slug)
  end
end

