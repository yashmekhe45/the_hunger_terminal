Rails.application.routes.draw do
  
  resources :orders
  get 'home/index'
  get 'order/load_terminal' => 'orders#load_terminal' ,:as => 'vendors'
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
  resources :companies do
    resources :terminals do
      resources :menu_items
      member { post :import }
    end
  end  

  resources :companies
  
  get 'terminals/download' => 'terminals#download'

  get 'custom_actions/selected_terminals' 

  root to: 'home#index'
  
  root to: 'home#index'
  get 'companie/:company_id/terminals' => 'custom_actions#selected_terminals' , :as => 'selection'
  get 'company/:company_id/menus' => 'menu_items#menu_index' , :as => 'menus'
end
