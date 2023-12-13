Rails.application.routes.draw do
  root "boards#index"

  # * to handle routing errors in the controller, use this line:
  # match '*unmatched', to: 'application#render_not_found', via: :all

  resource :session, only: %i[new create destroy]
  resource :passcode, only: %i[new create]

  resources :boards,
            path: '/',
            only: %i[show],
            param: :name do
    post "threads/close/:id", to: "topics#close", as: "close_topic"
    post "threads/open/:id", to: "topics#open", as: "open_topic"
    resources :threads,
              only: %i[show new create destroy],
              as: :topics,
              controller: :topics do
      resources :posts, only: %i[new create update destroy]
    end
  end

  namespace :admin do
    resources :users, only: %i[index new create update destroy]
    resources :boards, only: %i[index new create destroy], param: :name

    post "boards/close/:name", to: "boards#close", as: "close_board"
    post "boards/open/:name", to: "boards#open", as: "open_board"
  end
end
