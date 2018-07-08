Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'posts#index'

  resources :posts, :users, except: [:new, :edit, :destroy]
  get   'settings/edit', to: 'settings#edit',   as: :edit_setting
  patch 'settings/edit', to: 'settings#update', as: nil
  put   'settings/edit', to: 'settings#update', as: nil
  ActiveAdmin.routes(self)

  # API用
  post '/api/jobs', to: 'api#create'
end
