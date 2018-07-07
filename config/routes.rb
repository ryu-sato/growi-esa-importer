Rails.application.routes.draw do
  get '/', to: 'posts#index'

  resources :posts, :users, except: [:new, :edit, :destroy]
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
