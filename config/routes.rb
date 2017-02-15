Rails.application.routes.draw do
  
  get 'home/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :skip => [:registration]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  resources :companies
  
  root to: 'home#index'
end
