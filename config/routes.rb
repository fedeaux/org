Rails.application.routes.draw do

  devise_for :users
  namespace :api do
    namespace :v1 do
    end
  end

  get '*a' => 'dashboard#index', constraints: lambda { |req| req.format == :html }
  root 'dashboard#index'
end
