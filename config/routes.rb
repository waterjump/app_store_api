Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :apps, only: [:index]
    resources :publishers, only: [:index]
  end
end
