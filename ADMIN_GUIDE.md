# Hướng dẫn sử dụng Admin Panel - HUGE

## Đăng nhập Admin

1. Truy cập: `http://localhost:3000/admin`
2. Đăng nhập với tài khoản AdminUser
3. Nếu chưa có tài khoản, tạo bằng lệnh:

```ruby
rails console
AdminUser.create!(email: 'admin@huge.com', password: 'password123', password_confirmation: 'password123')
```

## Quản lý Sản phẩm

### Tạo sản phẩm mới

1. Vào menu **Sản phẩm** → **New Product**
2. Điền thông tin:
   - **Tên sản phẩm**: Bắt buộc
   - **Slug**: Tự động tạo từ tên nếu để trống
   - **Mã SKU**: Mã sản phẩm
   - **Danh mục**: Chọn danh mục
   - **Trạng thái**: draft hoặc published
   - **Sản phẩm nổi bật**: Check nếu muốn hiển thị ở trang chủ

### Upload nhiều ảnh

1. Trong form tạo/sửa sản phẩm, phần **Hình ảnh sản phẩm**
2. Click **Choose Files** và chọn nhiều ảnh cùng lúc (giữ Ctrl/Cmd để chọn nhiều)
3. Ảnh sẽ được upload và hiển thị trong phần "Ảnh hiện tại"
4. Để xóa ảnh, click nút **Xóa** bên dưới mỗi ảnh

### Rich Text Fields

- **Mô tả**: Mô tả chi tiết sản phẩm (Action Text)
- **Thông số kỹ thuật**: Thông số kỹ thuật sản phẩm (Action Text)
- **Hướng dẫn sử dụng**: Hướng dẫn sử dụng sản phẩm (Action Text)

Các trường này hỗ trợ:
- Formatting text (bold, italic, underline)
- Lists (ordered, unordered)
- Links
- Images
- Tables

### Properties (JSON)

Thêm thuộc tính bổ sung dưới dạng JSON:

```json
{
  "material": "Ceramic",
  "color": "White",
  "size": "Standard",
  "weight": "25kg",
  "warranty": "10 years"
}
```

### Batch Actions

- **Publish**: Chuyển các sản phẩm đã chọn sang trạng thái published
- **Draft**: Chuyển các sản phẩm đã chọn sang trạng thái draft

## Dashboard

Dashboard hiển thị:
- Thống kê sản phẩm (tổng số, published, draft, nổi bật)
- Sản phẩm mới nhất
- Thống kê danh mục
- Thống kê tin tức
- Thống kê Leads

## Lưu ý

1. Slug phải là duy nhất
2. Ảnh đầu tiên sẽ được hiển thị làm ảnh đại diện
3. Sản phẩm phải có status = published để hiển thị trên website
4. Properties phải là JSON hợp lệ

