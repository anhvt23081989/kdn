# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create AdminUser for Active Admin
AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end if Rails.env.development?

# Create User with admin role (optional, for testing)
User.find_or_create_by!(email: 'admin@tarin.com.vn') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = :admin
  user.confirmed_at = Time.current
end if Rails.env.development?

# Create User with guest role (optional, for testing)
User.find_or_create_by!(email: 'guest@tarin.com.vn') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = :guest
  user.confirmed_at = Time.current
end if Rails.env.development?