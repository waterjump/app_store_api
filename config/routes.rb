Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    get '/reports/:id', to: 'reports#show'
  end
end
