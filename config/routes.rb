Rails.application.routes.draw do
  # Locale scope
  scope "(:locale)", locale: /vi|en|th/ do
    root "home#index"

    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      confirmations: 'users/confirmations'
    }
    
    # Confirmation instructions page
    get "/confirmation-instructions", to: "users/confirmations_instructions#show", as: :confirmation_instructions
    devise_for :admin_users, ActiveAdmin::Devise.config.merge(controllers: {
      sessions: 'admin_users/sessions'
    })
    ActiveAdmin.routes(self)

    get  "/shop", to: "products#index"
    resources :products, path: "san-pham", only: [:index, :show], param: :slug

    resources :categories, path: "danh-muc", only: [:show], param: :slug

    resources :posts, path: "tin-tuc", only: [:index, :show], param: :slug
    resources :videos, path: "video", only: [:index]

    resources :catalogues, path: "catalogue", only: [:index]
    resources :leads, only: [:new, :create] # form đăng ký nhận catalogue

    get "/pages/:slug", to: "pages#show", as: :page

    # System Settings (admin only)
    get "/system-settings", to: "system_settings#menu", as: :system_settings_menu
    
    # Profile and Password management (authenticated users)
    get "/profile/edit", to: "profiles#edit", as: :edit_profile
    patch "/profile", to: "profiles#update", as: :profile
    get "/password/edit", to: "passwords#edit", as: :change_password
    patch "/password", to: "passwords#update", as: :update_password
  end

  # Language switcher
  get "/locale/:locale", to: "locales#set_locale", as: :set_locale
end
