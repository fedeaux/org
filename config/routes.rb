Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      get 'bundles/page' => 'bundles#page', format: 'js'
      get 'bundles/theme' => 'bundles#theme', format: 'css'
      get 'bundles' => 'bundles#index'
      resources :tats
      get 'uninstall' => 'callbacks#uninstall'
    end
  end

  get 'examples' => 'examples#index'
  get 'examples/:example' => 'examples#show'
end
