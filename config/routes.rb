Rails.application.routes.draw do
  get 'test_widget/index'

  root 'static_pages#index'

  resources :webpages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
