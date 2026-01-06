# Cấu trúc Layout - HUGE Website

## Tổng quan

Hệ thống được tổ chức với 2 layout chính:
- **Public Layout**: Cho người dùng chưa đăng nhập (frontend)
- **Admin Layout**: Cho người dùng đã đăng nhập (admin/backend)

## Cấu trúc Layout

### 1. Public Layout (`app/views/layouts/public.html.erb`)
- Sử dụng cho tất cả các trang public (chưa login)
- Bao gồm:
  - Header với mega menu (`shared/_public_header`)
  - Footer (`shared/_public_footer`)
  - Catalogue modal (`shared/catalogue_modal`)
  - JavaScript riêng (`public.js`)

### 2. Admin Layout (`app/views/layouts/application.html.erb`)
- Sử dụng cho các trang admin (đã login)
- Bao gồm:
  - Admin header (`shared/_admin_header`)
  - Footer (nếu cần)
  - Layout tối giản, tập trung vào nội dung

## Controllers

### Public Controllers (`Public::BaseController`)
Tất cả controllers cho frontend kế thừa từ `Public::BaseController`:
- `HomeController`
- `ProductsController`
- `CategoriesController`
- `PostsController`
- `VideosController`
- `CataloguesController`
- `PagesController`
- `LeadsController`

### Admin Controllers (`Admin::BaseController`)
Các controllers cho admin kế thừa từ `Admin::BaseController`:
- ActiveAdmin tự động sử dụng layout riêng
- Có thể tạo thêm controllers admin tùy chỉnh nếu cần

## Shared Partials

### Public Partials
- `shared/_public_header.html.erb`: Header với logo, search, navigation
- `shared/_public_footer.html.erb`: Footer với thông tin công ty, links, map
- `shared/_mega_menu.html.erb`: Mega menu với dropdown cho các danh mục
- `shared/_catalogue_modal.html.erb`: Modal form đăng ký nhận catalogue

### Admin Partials
- `shared/_admin_header.html.erb`: Header đơn giản cho admin với link về trang chủ

## JavaScript

### Public JavaScript (`app/assets/javascripts/public.js`)
- Catalogue modal functions
- Tab switching cho product categories
- Form submission handling
- Product loading via AJAX

## CSS

### Custom Styles (`app/assets/stylesheets/application.css`)
- Mega menu styles
- Product card hover effects
- Form input focus styles
- Responsive utilities
- Print styles

## Cách sử dụng

### Thêm controller mới cho public:
```ruby
class NewController < Public::BaseController
  # Tự động sử dụng layout "public"
end
```

### Thêm controller mới cho admin:
```ruby
class Admin::NewController < Admin::BaseController
  # Tự động sử dụng layout "application" và yêu cầu đăng nhập
end
```

## Lợi ích

1. **Tách biệt rõ ràng**: Public và admin có layout riêng, dễ maintain
2. **Dễ mở rộng**: Thêm controller mới chỉ cần kế thừa đúng base controller
3. **Tái sử dụng**: Shared partials có thể dùng lại ở nhiều nơi
4. **Performance**: JavaScript chỉ load khi cần (public layout)
5. **Bảo mật**: Admin controllers tự động yêu cầu authentication

