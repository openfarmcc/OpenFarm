# frozen_string_literal: true

OpenFarm::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, controllers: { registrations: 'registrations', confirmations: 'confirmations' }

  scope '(:locale)', locale: /en|nl/ do
    root to: 'homes#show'
    post '(:locale)/crop_search' => 'crop_searches#search', as: :crop_search_via_post
    get '(:locale)/crop_search' => 'crop_searches#search', as: :crop_search_via_get

    devise_scope :users do
      get 'users/gardens' => 'users#gardens'
      get 'users/finish' => 'users#finish'
      get 'users/edit' => 'users#edit'
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

  namespace :api, defaults: { format: 'json' } do
    get '/aws/s3_access_token' => 'aws#s3_access_token'
    post '/local/upload_file' => 'file_upload#upload_file'

    namespace :v1 do
      get '/progress/pictures/:obj_type/:obj_id' => 'progress_job#show'

      resources :crops, only: %i[create index show update] do
        resources :pictures, only: %i[index show]
      end
      resources :tags, only: :index do
        collection { get '/:query', action: :index }
      end
      resources :guides, only: %i[create show update destroy]
      resources :users, only: %i[show update] do
        resources :gardens, only: %i[index]
        resources :compatibility_score, only: %i[show]
      end
      resources :gardens, only: %i[create show update destroy] do
        resources :garden_crops, only: %i[index show create update destroy]
      end
      resources :detail_options, only: %i[index]
      resources :stage_options, only: %i[index]
      resources :stage_action_options, only: %i[index]
      resources :stages, only: %i[create show update destroy] do
        resources :pictures, only: %i[index], controller: 'stages', action: 'pictures'
        resources :stage_actions, only: %i[index destroy]
        # controller: 'stages',
        # action: 'stage_actions'
      end

      resources :tokens, path: 'token', only: %i[create] do
        collection { delete :destroy }
      end
    end
  end

  get '/:locale' => 'homes#show'
end
