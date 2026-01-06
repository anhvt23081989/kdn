# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Thống kê sản phẩm" do
          ul do
            li "Tổng số sản phẩm: #{Product.count}"
            li "Sản phẩm đã publish: #{Product.published.count}"
            li "Sản phẩm draft: #{Product.where(status: :draft).count}"
            li "Sản phẩm nổi bật: #{Product.where(featured: true).count}"
          end
        end

        panel "Sản phẩm mới nhất" do
          ul do
            Product.order(created_at: :desc).limit(5).map do |product|
              li link_to(product.name, admin_product_path(product))
            end
          end
        end
      end

      column do
        panel "Thống kê danh mục" do
          ul do
            li "Tổng số danh mục: #{Category.count}"
            li "Danh mục có sản phẩm: #{Category.joins(:products).distinct.count}"
          end
        end

        panel "Thống kê tin tức" do
          ul do
            li "Tổng số bài viết: #{Post.count}"
            li "Bài viết đã publish: #{Post.published.count}"
          end
        end

        panel "Thống kê Leads" do
          ul do
            li "Tổng số đăng ký: #{Lead.count}"
            li "Đăng ký hôm nay: #{Lead.where("created_at >= ?", Date.today).count}"
          end
        end
      end
    end
  end
end
