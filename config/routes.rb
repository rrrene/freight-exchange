BlackBoard::Application.routes.draw do |map|
  match "setup" => 'setup#index', :as => :setup  
  match "not_seeded" => 'setup#not_seeded', :as => :not_seeded
  match "demo_company" => 'setup#demo_company', :as => :demo_company
  
  match "tolk_import" => 'setup#tolk_import', :as => :tolk_import
  match "tolk_sync_all" => 'setup#tolk_sync', :as => :tolk_sync
  match "tolk_dump_all" => 'setup#tolk_dump_all', :as => :tolk_dump_all
  
  resources :reviews do
    member do
      post :approve
    end
  end
  
  resources :loading_spaces

  resources :people

  resources :freights
  resources :companies

  resources :stations
  resources :postings
  resources :loading_spaces, :controller => :postings
  resources :users

  match "about" => "root#about", :as => :about
  
  resources :users
  resources :user_sessions do
    collection do
      get :demo_login
    end
  end
  
  match "welcome" => 'root#welcome', :as => :after_login
  match "first_steps" => 'root#welcome', :as => :after_company_creation
  
  match "my_profile" => 'users#edit', :as => :my_profile
  match "register" => 'companies#new', :as => :register
  match "login" => 'user_sessions#new', :as => :login
  match "logout" => 'user_sessions#destroy', :as => :logout
  
  match "search" => 'search#index', :as => :search
  match "advanced" => 'search#advanced', :as => :advanced_search
  match "dashboard" => 'companies#dashboard', :as => :company_dashboard

  match "contact" => 'contact#index', :as => :contact
  
  root :to => "root#index"
  
  namespace :admin do
    resources :app_configs do
      collection do
        get :reimport_defaults 
      end
    end
    resources :companies
    resources :freights # BEWARE: not implemented
    resources :loading_spaces # BEWARE: not implemented
    resources :people # BEWARE: not implemented
    resources :reviews # BEWARE: not implemented
    resources :action_recordings
    resources :search_recordings do
      collection do
        get :keyword
      end
    end
    resources :user_roles
    resources :users
    root :to => "setup#redirect"
    match "search", :to => "search#index", :as => :search
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
