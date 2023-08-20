Rails.application.routes.draw do
  get 'topics/index'
  get 'topics/show'
  get 'topics/new'
  get 'topics/create'
  root 'boards#index'

  get '/:id', to: 'boards#show'
end
