Floxy::Application.routes.draw do
  self.default_url_options Settings.app.default_url_options.symbolize_keys

  ## scope subdomain: 'api', constraints: { subdomain: 'api' } do
  #mount GrapeSwaggerRails::Engine => '/api'
  #mount API => '/api'
 
  #devise_for :admin_users, ActiveAdmin::Devise.config

  #ActiveAdmin.routes(self)

  root 'welcome#index'

  resources :organizations, path: "a", only: [:show, :index, :create, :edit, :update, :new, :destroy] do
    resources :tasks do
      post :negotiate
      post :approve
      post :hold
      post :start
      post :defer
      post :finish
      post :accept
      post :reject
    end
    resources :milestones do
      post :negotiate
      post :start
      post :hold
      post :finish
      post :accept
      post :reject
    end
    resources :projects, only: [:show, :index, :create, :edit, :update, :new, :destroy]
    resources :task_levels, only: [:index, :edit, :create, :edit, :update, :destroy]
    get 'settings' => 'settings#index'
    resources :profiles, only: [:show, :index, :edit, :update]
    get 'me' => 'profiles#show_current'
  end

  devise_for :users

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
