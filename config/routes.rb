Floxy::Application.routes.draw do
  self.default_url_options Settings.app.default_url_options.symbolize_keys

  ## scope subdomain: 'api', constraints: { subdomain: 'api' } do
  #mount GrapeSwaggerRails::Engine => '/api'
  #mount API => '/api'
 
  #devise_for :admin_users, ActiveAdmin::Devise.config

  #ActiveAdmin.routes(self)

  root 'organizations#index'

  resources :organizations, path: "a" do
    member do
      post :create_membership
    end
    scope :module=>:organization do
      resources :tasks, only: [:index] do
        get 'done', on: :collection
        get 'without_milestone', on: :collection
        get 'review', on: :collection
        get 'negotiate', on: :collection
      end
      resources :members, only: [:index, :show, :edit, :update]
      resources :teams do
        member do
          post :create_membership
        end
      end
      resources :milestones, only: [:index]
      resources :projects do
        member do
          get :planning
          get :done
          get :empty
        end
        resources :milestones, :except=>[:index], :controller => 'project_milestones' do
          member do
            get :negotiate
            get :start
            get :hold
            get :finish
            get :accept
            get :reject
            get :print
            get :planning
            get :done
          end
          resources :tasks, :except=>[:index], :controller => 'milestone_tasks' do
            member do
              get :negotiate
              get :approve
              get :hold
              get :start
              get :defer
              get :finish
              get :accept
              get :reject
            end
          end
        end
      end

      get 'me' => 'members#show_current'
      resource :settings, only: [:show]
      resources :task_levels, except: [:show]
      resources :user_invoices, only: [:index, :new, :create, :show, :destroy]
    end
  end

  get '/ui' => 'ui#index'
  get '/ui/:slug' => 'ui#show'
  get '/ui/:feature/:slug' => 'ui#show_nested'

  get 'switch_user' => 'switch_user#set_current_user'

  devise_for :users
end
