Rails.application.routes.draw do
  root 'landing#index'
  
  get 'landing', to: 'landing#index', as: 'landing'

  get 'test_widget/with_script'
  get 'test_widget/another_with_script'
  get 'test_widget/without_script'

  get 'test_pages', to: 'static_pages#index', as: 'test_pages'

  resources :webpages

  # Widget
  get 'widget_init', to: 'widget/root#init'
  get 'widget_root', to: 'widget/root#root'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
