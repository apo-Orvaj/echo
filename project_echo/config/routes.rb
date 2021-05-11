Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resources :endpoints, only: %i[index create update destroy]

  resources :auth, only: :create, path: 'authentication_token'

  match '*path', to: 'endpoints#show', via: :all
end
