Rails.application.routes.draw do
  # get 'topics/show'
  # get 'topics/new'
  # get 'topics/create'
  root 'boards#index'

  
  # get '/:id', to: 'boards#show' do
  resources :boards, path: '/', only: [:show] do
    resources :threads,  only: [:show, :new, :create], as: :topics, controller: :topics do
      resources :posts, only: [:create]
    end
      # get '/thread/:id', to: 'topics#show'
      # get '/thread/new', to: 'topics#new'
      # post '/topics/create', to: 'topics#create'
  end

end
