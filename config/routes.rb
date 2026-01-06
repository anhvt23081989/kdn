Rails.application.routes.draw do
  root "home#index"

  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get  "/shop", to: "products#index"
  resources :products, path: "san-pham", only: [:index, :show], param: :slug

  resources :categories, path: "danh-muc", only: [:show], param: :slug

  resources :posts, path: "tin-tuc", only: [:index, :show], param: :slug
  resources :videos, path: "video", only: [:index]

  resources :catalogues, path: "catalogue", only: [:index]
  resources :leads, only: [:new, :create] # form đăng ký nhận catalogue

  get "/pages/:slug", to: "pages#show", as: :page
end
