ActiveAdmin.register Product do
  menu priority: 1, label: "Sản phẩm"

  permit_params :name, :slug, :sku, :category_id, :status, :featured, :properties,
                images: []

  # Index page
  index do
    selectable_column
    id_column
    column "Ảnh" do |product|
      if product.images.attached?
        image_tag product.images.first.variant(resize_to_limit: [100, 100]), style: "max-width: 100px; max-height: 100px;"
      else
        "Không có ảnh"
      end
    end
    column :name
    column :sku
    column :category
    column :status do |product|
      status_tag product.status, product.published? ? :ok : :warning
    end
    column :featured do |product|
      status_tag product.featured? ? "Có" : "Không", product.featured? ? :ok : nil
    end
    column :created_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :sku
      row :category
      row :status do |product|
        status_tag product.status, product.published? ? :ok : :warning
      end
      row :featured do |product|
        status_tag product.featured? ? "Có" : "Không", product.featured? ? :ok : nil
      end
      row :properties do |product|
        if product.properties.present?
          pre JSON.pretty_generate(product.properties)
        else
          "Không có"
        end
      end
      row :images do |product|
        if product.images.attached?
          div do
            product.images.each do |image|
              div style: "display: inline-block; margin: 5px;" do
                image_tag image.variant(resize_to_limit: [200, 200])
              end
            end
          end
        else
          "Không có ảnh"
        end
      end
      row :description do |product|
        product.description if product.description.present?
      end
      row :specification do |product|
        product.specification if product.specification.present?
      end
      row :manual do |product|
        product.manual if product.manual.present?
      end
      row :created_at
      row :updated_at
    end
  end

  # Form
  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Thông tin cơ bản" do
      f.input :name, label: "Tên sản phẩm", required: true
      f.input :slug, label: "Slug (URL)", hint: "Tự động tạo từ tên nếu để trống"
      f.input :sku, label: "Mã SKU"
      f.input :category, label: "Danh mục", as: :select, collection: Category.all.map { |c| [c.name, c.id] }, required: true
      f.input :status, label: "Trạng thái", as: :select, collection: Product.statuses.keys.map { |k| [k.humanize, k] }
      f.input :featured, label: "Sản phẩm nổi bật"
    end

    f.inputs "Hình ảnh sản phẩm" do
      f.input :images, as: :file, input_html: { multiple: true, accept: "image/*" }, label: "Upload nhiều ảnh", hint: "Có thể chọn nhiều ảnh cùng lúc"
      if f.object.images.attached?
        f.inputs "Ảnh hiện tại" do
          f.object.images.each_with_index do |image, index|
            div style: "margin: 10px 0; padding: 10px; border: 1px solid #ddd; display: inline-block; margin-right: 10px;" do
              image_tag image.variant(resize_to_limit: [200, 200])
              br
              text_node link_to "Xóa", delete_image_admin_product_path(f.object, image_id: image.id), method: :delete, 
                        data: { confirm: "Bạn có chắc muốn xóa ảnh này?" }, 
                        class: "button", style: "margin-top: 5px;"
            end
          end
        end
      end
    end

    f.inputs "Mô tả sản phẩm" do
      f.input :description, as: :rich_text_area, label: "Mô tả"
    end

    f.inputs "Thông số kỹ thuật" do
      f.input :specification, as: :rich_text_area, label: "Thông số"
    end

    f.inputs "Hướng dẫn sử dụng" do
      f.input :manual, as: :rich_text_area, label: "Hướng dẫn"
    end

    f.inputs "Thuộc tính bổ sung (JSON)" do
      f.input :properties, as: :text, label: "Properties (JSON format)", 
              hint: "Ví dụ: {\"material\": \"Ceramic\", \"color\": \"White\", \"size\": \"Standard\"}",
              input_html: { value: f.object.properties.present? ? JSON.pretty_generate(f.object.properties) : "{}", rows: 10 }
    end

    f.actions
  end

  # Filters
  filter :name, label: "Tên sản phẩm"
  filter :sku, label: "Mã SKU"
  filter :category, label: "Danh mục"
  filter :status, label: "Trạng thái", as: :select, collection: Product.statuses.keys.map { |k| [k.humanize, k] }
  filter :featured, label: "Sản phẩm nổi bật"
  filter :created_at, label: "Ngày tạo"

  # Custom action to delete image
  member_action :delete_image, method: :delete do
    if params[:image_id].present?
      image = ActiveStorage::Attachment.find_by(id: params[:image_id])
      if image && image.record == resource
        image.purge
        redirect_to admin_product_path(resource), notice: "Ảnh đã được xóa thành công"
      else
        redirect_to admin_product_path(resource), alert: "Không tìm thấy ảnh hoặc ảnh không thuộc sản phẩm này"
      end
    else
      redirect_to admin_product_path(resource), alert: "Thiếu thông tin ảnh"
    end
  end

  # Batch actions
  batch_action :publish, confirm: "Bạn có chắc muốn publish các sản phẩm đã chọn?" do |ids|
    Product.where(id: ids).update_all(status: :published)
    redirect_to collection_path, notice: "Đã publish #{ids.count} sản phẩm"
  end

  batch_action :draft, confirm: "Bạn có chắc muốn chuyển các sản phẩm đã chọn sang draft?" do |ids|
    Product.where(id: ids).update_all(status: :draft)
    redirect_to collection_path, notice: "Đã chuyển #{ids.count} sản phẩm sang draft"
  end

  # Controller
  controller do
    def create
      @product = Product.new(permitted_params[:product])
      
      # Auto-generate slug from name if not provided
      if @product.slug.blank? && @product.name.present?
        @product.slug = @product.name.parameterize
      end

      # Parse properties JSON if provided
      if params[:product][:properties].present?
        begin
          @product.properties = JSON.parse(params[:product][:properties])
        rescue JSON::ParserError => e
          @product.errors.add(:properties, "JSON không hợp lệ: #{e.message}")
        end
      end

      if @product.save
        redirect_to admin_product_path(@product), notice: "Sản phẩm đã được tạo thành công"
      else
        render :new
      end
    end

    def update
      @product = Product.find(params[:id])
      
      # Auto-generate slug from name if not provided
      if params[:product][:slug].blank? && params[:product][:name].present?
        params[:product][:slug] = params[:product][:name].parameterize
      end

      # Parse properties JSON if provided
      if params[:product][:properties].present?
        begin
          params[:product][:properties] = JSON.parse(params[:product][:properties])
        rescue JSON::ParserError => e
          @product.errors.add(:properties, "JSON không hợp lệ: #{e.message}")
        end
      end

      if @product.update(permitted_params[:product])
        redirect_to admin_product_path(@product), notice: "Sản phẩm đã được cập nhật thành công"
      else
        render :edit
      end
    end
  end
end

