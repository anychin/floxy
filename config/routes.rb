Floxy::Application.routes.draw do
  self.default_url_options Settings.app.default_url_options.symbolize_keys

  ## scope subdomain: 'api', constraints: { subdomain: 'api' } do
  #mount GrapeSwaggerRails::Engine => '/api'
  #mount API => '/api'
 
  #devise_for :admin_users, ActiveAdmin::Devise.config

  #ActiveAdmin.routes(self)

  root 'organizations#index'

  resources :organizations, path: "a" do
    scope :module=>:organization do
      resources :tasks, only: [:index] do
        get 'done', on: :collection
        get 'without_milestone', on: :collection
      end
      resources :members, only: [:index, :show, :edit, :update]
      resources :teams
      resources :milestones, only: [:index]
      resources :projects do
        resources :milestones, :except=>[:index], :controller => 'project_milestones' do
          member do
            post :negotiate
            post :start
            post :hold
            post :finish
            post :accept
            post :reject
            get :print
          end
          resources :tasks, :except=>[:index], :controller => 'milestone_tasks' do
            member do
              post :negotiate
              post :approve
              post :hold
              post :start
              post :defer
              post :finish
              post :accept
              post :reject
            end
          end
        end
      end

      get 'me' => 'members#show_current'
      resource :settings, only: [:show]
      resources :task_levels, except: [:show]
      resources :user_invoices, only: [:index, :new]
    end
  end

  devise_for :users
end
