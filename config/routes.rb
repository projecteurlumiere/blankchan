Rails.application.routes.draw do
  root "boards#index"

  # * to handle routing errors in the controller, use this line:
  # match '*unmatched', to: 'application#render_not_found', via: :all

  resource :session, only: %i[new create destroy]
  resource :passcode, only: %i[new create]

  namespace :admin do
    resources :users, only: %i[index new create update destroy]
    resources :boards, only: %i[index new create update destroy], param: :name
    resources :threads, only: %i[show], as: :topics, controller: :topics
  end

  resources :boards,
            path: '/',
            only: %i[show],
            param: :name do
    get "threads/show_admin/:id", to: "topics#show_admin", as: "admin_show_topic"
    resources :threads,
              only: %i[show new create update destroy],
              as: :topics,
              controller: :topics do
      resources :posts, only: %i[new create update destroy]
    end
  end


end
