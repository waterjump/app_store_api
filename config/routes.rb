Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :apps, only: [:index]
  end
end
