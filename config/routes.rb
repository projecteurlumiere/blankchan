Rails.application.routes.draw do
  root 'boards#index'

  get '/:id', to: 'boards#show'
end
