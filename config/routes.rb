Rails.application.routes.draw do
  root 'boards#index'

  resources :boards,
            path: '/',
            only: %i[show],
            param: :name do
    resources :threads,
              only: %i[show new create],
              as: :topics,
              controller: :topics do
      resources :posts, only: %i[create]
    end
  end
end
