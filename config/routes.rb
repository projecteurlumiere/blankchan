Rails.application.routes.draw do
  root 'boards#index'

  # * to handle routing errors in the controller, use this line:
  # match '*unmatched', to: 'application#render_not_found', via: :all

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
