Rails.application.routes.draw do
  
  root to: 'home#index'

  resources :order_details, only: :destroy

  get 'order/vendors' => 'orders#load_terminal' ,:as => 'vendors'
  get 'order/myOrder' => 'orders#order_history' ,:as => 'orders'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :skip => [:registration],  controllers: { confirmations: 'confirmation' }
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users' => 'devise/registrations#update', :as => 'user_registration'
  end 


  resources :companies do
    member do
      get 'get_order_details'
    end

    resources :users do
      collection do
        get 'search'
        get 'download_invalid_csv'
        post 'add_multiple_employee_records'
        post 'import'
      end
    end

    resources :terminals do
      resources :menu_items do
        collection do
          post :import
        end
      end

      resources :orders
    end
  end

  
  # get 'companies/:company_id/terminals/:id/invalid_menu_download' => 'terminals#invalid_menu_download'
 
  get "menu_items/download_csv"
  get 'users/download_sample_csv'
  get 'users/download_sample_xls'
  get 'users/download_sample_xlsx'

  get 'admin_dashboard/index'
  get 'admin_dashboard/order_detail'
  get 'admin_dashboard/forward_orders'
  get 'admin_dashboard/place_orders'
  get 'admin_dashboard/confirm_orders'
  get 'admin_dashboard/payment'
  get 'admin_dashboard/pay'
  # delete 'edit/order_detail_id' => 'orders#order_detail_remove',:as => 'order_detail_remove'

  get 'reports/index'
  get 'reports/individual_employee'
  get 'reports/order_details'
  get 'reports/employees_todays_orders'
  get 'reports/monthly_all_employees'
  get "reports/download_pdf" => "reports#download_pdf"
  get 'reports/all_terminals_last_month_reports'
  get 'reports/all_terminals_daily_report'
  get 'reports/individual_terminal_last_month_report'
  get 'reports/employees_daily_order_detail'
  get 'reports/download_daily_terminal_report'
  
  
end
