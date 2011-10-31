Sidelineswap::Application.routes.draw do
  get "contact/index"
  
  post "payments/notify"

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
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
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
  #       get 'recent', :on => :collection
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
	
  namespace :admin do
    root :to => "welcome#index"
    resources :users, :except => [:create, :new] do
      resource :user_profile, :except => [:create, :new]
      resources :swaps, :only => [:index, :show]
      resources :items
    end
    resources :user_profiles, :except => [:create, :new]
    resources :lockers do
      resources :items
    end
    resources :lockers, :only => [:index]
    resources :items, :except => [:create, :new]
    resources :images, :except => [:create, :new]
    resources :categories do
      resources :items
    end
    resources :teams do
      resources :items
    end
    resources :images, :except => [:create, :new, :edit, :update]
    resources :user_profiles, :except => [:create, :new]
    resources :swaps, :only => [:index, :show]
  end

  resources :password_resets, :only =>  [ :new, :create, :edit, :update ]

   match "stores" => "stores#store_index", :as => :store_index

   match "store/new" => "stores#store_new", :as => :store_new

   match "store/create" => "stores#store_create", :as => :store_create

   match "store/edit" => "stores#store_edit", :as => :store_edit

   match "store/update" => "stores#store_update", :as => :store_update

  match "store/show/:id" => "stores#store_show", :as => :store_show

  match "store/store_edit_profile" => "stores#store_edit_profile", :as => :store_edit_profile

  match "store/store_update_profile" => "stores#store_update_profile", :as => :store_update_profile

  # Users

  resources :users, :except => [:index, :destroy] do
    resources :swaps
    resources :items, :only => :index
    resources :lockers, :only => :index
    resources :images, :only => :index
    resource :user_profile
  end

  # Items
  
  resources :items do
    collection do
      get :recent
      get :popular
    end

    member do
      post :comment
    end

    resources :images, :only => :index
  end

  # Lockers

  #resources :lockers do
  #  resources :items, :only => :index
  #end
  #resources :lockers, :only => :show

  # Categories
  
  resources :categories, :only => :index do
    resources :items, :only => :index do
      collection do
        get :recent
        get :popular
      end
    end
  end

  # Teams

  resources :teams, :only => [:index, :show] do
    collection do
      get :ac
    end

    member do
      get :short
    end
    
    resources :items do
      collection do
        get :recent
        get :popular
      end
    end

    resources :user_profiles, :only => :index
  end

  # Swaps

  resources :swaps, :only => [:accept, :decline, :extend, :confirm, :checkout, :thanks] do
    member do
      post :accept
      post :decline
      post :extend
      post :confirm
      post :complete
      post :checkout
      get :checkout
      get :confirm
      get :thanks
    end
  end

  # Offers (aka Swaps)

  resources :offers, :only => [:accept, :decline, :extend, :confirm, :checkout, :thanks],
    :controller => 'swaps', :resource_path => '/swaps' do
    member do
      post :accept
      post :decline
      post :extend
      post :confirm
      post :checkout
      get :checkout
      get :thanks
      get :confirm
    end
  end

  # Categories

  resources :categories, :only => :index do
    resources :items, :only => :index do
      collection do
        get :recent
        get :popular
      end
    end
  end
  

  get    'contact'          => 'contact#new',             :as => :contact
  post   'contact'          => 'contact#create',          :as => :contact
  get    'about'            => 'pages#show',              :id => :about
  get    'shipping'         => 'pages#show',              :id => :shipping
  get    'terms'            => 'pages#show',              :id => :terms
  get    'privacy'          => 'pages#show',              :id => :privacy
  get    'help'             => 'pages#show',              :id => :help

  get    'register'         => 'users#new',             :as => :register
  get    'login(.:format)'  => 'user_sessions#new',     :as => :login
  post   'login(.:format)'  => 'user_sessions#create',  :as => :login
  delete 'logout(.:format)' => 'user_sessions#destroy', :as => :logout

 # match '/lockers/:id' => "lockers#show", :as=>:lockers
resources :lockers

  root :to => "welcome#index"
end
