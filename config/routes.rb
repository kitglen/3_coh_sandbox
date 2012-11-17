AppTemplate::Application.routes.draw do

  devise_for :admins, :path => "admin", :skip => [:registrations], :controllers => { :sessions => "admins/sessions" }
    as :admin do
      get 'admins/edit' => 'devise/registrations#edit', :as => 'edit_admin_registration'
      put 'admins' => 'devise/registrations#update', :as => 'admin_registration'
      get 'admin', :to => 'admin#index', :as => :admin_root
    end
  apipie
  namespace :api do
    namespace :v1 do
      
        resources :doctors
      
    end # v1
    
    namespace :v2 do
      
        resources :doctors
      
    end # v2
    
    # Mount rails engine gems.
    
  end

  namespace :admin do
    
      resources :doctors
    
  end
  get '/admin' => 'admin#index'

  root :to => 'root#index'
end
