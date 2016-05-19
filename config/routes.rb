require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, path: ''

  authenticated :user do
    root to: 'dashboard#user', as: :user_root
    match '/oauth/:provider_textkey/callback', to: 'credentials#auth', via: [:get, :post]

    resources :providers, param: :textkey do
      resources :credentials, only: [:new, :create, :edit, :update]
    end
  end

  unauthenticated do
    root to: 'home#index'
  end

  resources :templates do
    resources :deployments, only: [:index, :new, :edit, :create, :destroy] do
      collection do
        post 'validate', to: 'deployments#validate', as: 'validate'
        post 'options/:type', to: 'deployments#options', as: 'options'
      end
    end
  end

  # TODO: Probably obsolete URLs
  resources :deployments, only: :show
  get '/deployments', to: 'deployments#all'

  authenticate :user, -> (u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
    resources :providers, except: :show
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
