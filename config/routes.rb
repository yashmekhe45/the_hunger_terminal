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
      resources :menu_items do
        collection { post :import }
      # member { get :download }
      end 
    end  
  end  

  resources :companies
  
  # get 'companies/:company_id/terminals/:id/invalid_menu_download' => 'terminals#invalid_menu_download'
 


  get 'admin_dashboard/index'
  get 'admin_dashboard/order_detail'
  get 'admin_dashboard/confirm'
  get 'admin_dashboard/place_orders'
  get 'reports/index'
  root to: 'home#index'
  
  get 'companies/:company_id/terminals' => 'admin_dashboard#selected_terminals' , :as => 'selection'
  get 'company/:company_id/menus' => 'menu_items#menu_index' , :as => 'menus'
end
