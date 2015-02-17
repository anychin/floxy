Floxy::Application.routes.draw do
  self.default_url_options Settings.app.default_url_options.symbolize_keys

  ## scope subdomain: 'api', constraints: { subdomain: 'api' } do
  #mount GrapeSwaggerRails::Engine => '/api'
  #mount API => '/api'
 
  #devise_for :admin_users, ActiveAdmin::Devise.config

  #ActiveAdmin.routes(self)

  root 'tasks#index'

  resources :organizations, only: [:show, :index, :create, :edit, :update, :new, :destroy] do
    resources :tasks, only: [:show, :index, :create, :edit, :update, :new, :destroy]
    resources :projects, only: [:show, :index, :create, :edit, :update, :new, :destroy]
    resources :milestones, only: [:show, :index, :create, :edit, :update, :new, :destroy]
    resources :task_levels, only: [:index, :edit, :create, :edit, :update, :destroy]
  end

  resources :profiles, only: [:show, :index]

  devise_for :users

  get 'settings' => 'settings#index'
  get 'me' => 'profiles#show_current'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
