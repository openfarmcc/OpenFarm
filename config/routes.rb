OpenFarm::Application.routes.draw do

  devise_for :users,
    controllers: {
      omniauth_callbacks: "user_authentications",
      registrations: "registrations"
    }
  root :to => 'high_voltage/pages#show', id: 'home'

  # Accept searches via POST and GET so that users can search with forms -or-
  # shareable link.
  post 'crop_search' => 'crop_searches#search', as: :crop_search_via_post
  get 'crop_search' => 'crop_searches#search', as:  :crop_search_via_get
  
  resources :users
  resources :crops
  resources :guides

  # Catch-all. Is this okay?
  match ':controller(/:action(/:id))', :via => [:get, :post ]

  # The priority is based upon order of creation: first created -> highest
  # priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions
  # automatically):
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
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
