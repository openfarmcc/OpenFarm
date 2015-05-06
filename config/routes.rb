OpenFarm::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, controllers: {
      registrations: "registrations",
      confirmations: "confirmations"
    }

  scope '(:locale)', locale: /en|nl/ do
    root to: 'homes#show'
    post '(:locale)/crop_search' => 'crop_searches#search',
         as: :crop_search_via_post
    get '(:locale)/crop_search' => 'crop_searches#search',
        as: :crop_search_via_get

    devise_scope :users do
      get 'users/gardens' => 'users#gardens'
      get 'users/finish' => 'users#finish'
      put 'users' => 'users#update'
    end
    resources :users
    resources :crops
    resources :guides
    resources :stages
    resources :requirements
    resources :gardens
  end

  get 'announcements/hide', to: 'announcements#hide'

  namespace :api, defaults: {format: 'json'} do
    get '/aws/s3_access_token' => 'aws#s3_access_token'
    resources :crops, only: [:index, :show, :update]
    resources :users, only: [:show, :update]
    resources :guides, only: [:create, :show, :update, :destroy]
    resources :gardens, only: [:create, :show, :update, :destroy] do
      resources :garden_crops, only: [:index,
                                      :show,
                                      :create,
                                      :update,
                                      :destroy]
    end
    # resources :requirement_options, only: [:index]
    # resources :requirements, only: [:create, :show, :update, :destroy]
    resources :detail_options, only: [:index]
    resources :stage_options, only: [:index]
    resources :stage_action_options, only: [:index]
    resources :stages, only: [:create, :show, :update, :destroy]

    # TODO Figure out why I can't use a singular resource route here.
    post 'token', to: 'tokens#create'
    delete 'token', to: 'tokens#destroy'
  end

  get '/:locale' => 'homes#show'
end
