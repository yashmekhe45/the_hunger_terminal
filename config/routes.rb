require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda { |u| u.is_company_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'home#index'

  resources :order_details, only: :destroy

  get 'order/vendors' => 'orders#load_terminal' ,:as => 'vendors'
  get 'order/myOrder' => 'orders#order_history' ,:as => 'orders'
  get 'order/review' => 'orders#enter_review' ,:as => 'enter_review'
  get 'order/comments' => 'orders#show_comments' ,:as => 'show_comments'
  get 'order/skip_review' => 'reviews#skip_review' ,:as => 'skip_review'
  resource :reviews, only: [:create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :skip => [:registration],  controllers: { confirmations: 'confirmation' }
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users' => 'devise/registrations#update', :as => 'user_registration'
  end 


  resources :companies, shallow: true, only: [:new, :create, :update] do
    member do
      get 'get_order_details'
      get 'download_invalid_csv'
    end

    resources :users, except: [:destroy, :edit] do
      resources :orders, only: [] do 
        member do
          get 'details', to: 'reports#order_details'
        end
      end    
      collection do
        get 'search'
        post 'add_multiple_employee_records'
        post 'import'
      end    
    end

    resources :terminals, except: [:destroy, :show] do
      get 'download_invalid_csv'
      resources :orders, except: :index
      resources :menu_items, except: [:destroy, :show] do
        collection do
          post :import
        end
      end
    end  
  end

  scope '/reports', as: 'reports' do
    resources :users , only: [] do
      collection do
        get 'history', to: 'reports#monthly_all_employees'
        get 'mtd', to: 'reports#employees_current_month'
        get 'todays', to: 'reports#employees_daily_order_detail'
      end

      member do
        get 'history', to: 'reports#employee_history'
      end
    end

    resources :terminals, only: [] do
      collection do
        get 'history', to: 'reports#terminals_history'
        get 'mtd', to: 'reports#terminals_current_month'
        get 'todays', to: 'reports#terminals_todays'
      end

      member do
        get 'history', to: 'reports#terminal_history'
      end
    end
  end

  
 
  get "menu_items/download_csv"
  
  get '/users/download_sample_file/:file_type' => 'users#download_sample_file', as: :download_sample_file

  get 'admin_dashboard/index'
  get 'admin_dashboard/order_detail'
  get 'admin_dashboard/forward_orders'
  get 'admin_dashboard/place_orders'
  get 'admin_dashboard/confirm_orders'
  get 'admin_dashboard/cancel_orders'
  get 'admin_dashboard/payment'
  get 'admin_dashboard/pay'

  get 'admin_dashboard/input_terminal_extra_charges'
  post 'admin_dashboard/save_terminal_extra_charges'

  get '/OneClickOrder/:token/:order_id' => 'orders#one_click_order', as: :one_click_order


  

  # delete 'admin_dashboard/:id(.:format)', :to => 'admin_dashboard#destroy', :as => 'admin_dashboard_order_detail_remove'
  # delete 'edit/order_detail_id' => 'orders#order_detail_remove',:as => 'order_detail_remove'
  
end
