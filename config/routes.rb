Rails.application.routes.draw do

  root 'landing#index'

  get 'landing', to: 'landing#index', as: 'landing'

  get 'test_widget/with_script'
  get 'test_widget/another_with_script'
  get 'test_widget/without_script'

  get 'test_pages', to: 'static_pages#index', as: 'test_pages'

  namespace :workspace do
    get 'dashboard' => 'dashboard#index'
    resources :webpages
    get 'webpage_remove_modal/:id' => 'webpages#remove_modal', as: 'webpage_remove_modal'

    get 'confirm_widget_script/:id' => 'webpages#confirm_widget_script', as: 'confirm_widget_script'
  end

  namespace :ajax do
    get 'token_validation/:id/:token' => 'token_validation#index', as: 'token_validation'
  end


  # Users registration
  post 'registration' => 'users#create'
  get 'activate/:id' => 'users#activate', as: 'activate_user'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :password_resets

  # Dashboard
  get 'dashboard' => 'dashboard#index'


  # Widget
  get 'widget_init', to: 'widget/root#init'
  get 'widget_root', to: 'widget/root#root'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
