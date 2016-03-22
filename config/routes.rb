Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :reports, only: [:show]
  end
end
