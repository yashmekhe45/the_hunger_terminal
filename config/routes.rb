Rails.application.routes.draw do
  
  get 'home/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :skip => [:registration],  controllers: { confirmations: 'confirmation' }
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users' => 'devise/registrations#update', :as => 'user_registration'
  end  
  resources :companies do
    resources :users do
      get 'search', :on => :collection
      get 'download', :on => :collection
      collection { post :import }
    end

  end

  resources :terminals do
    resources :menu_items
    member { post :import }
  end

  resources :companies
  
  get 'terminals/download' => 'terminals#download'

  root to: 'home#index'
  
  get 'menu_items/menu_index' => 'menu_items#menu_index'
end
