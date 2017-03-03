Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#home'

  namespace :admin do
    constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
      get '/' => 'dashboards#show', as: :admin_root

      resource :award_categories, only: [:new, :create]
      get 'award_categories' => 'award_categories#index', as: :index_award_categories
      get 'award_categories/:id/edit' => 'award_categories#edit', as: :edit_award_category
      post 'award_categories/:id/update' => 'award_categories#update', as: :update_award_category
      post 'award_categories/:id/delete' => 'award_categories#delete', as: :delete_award_category

      resource :award_seasons, only: [:new, :create]
      get 'award_seasons' => 'award_seasons#index', as: :index_award_seasons
      get 'award_seasons/:id/edit' => 'award_seasons#edit', as: :edit_award_season
      post 'award_seasons/:id/update' => 'award_seasons#update', as: :update_award_season
      post 'award_seasons/:id/delete' => 'award_seasons#delete', as: :delete_award_season

      resource :awards, only: [:new, :create]
      get 'awards' => 'awards#index', as: :index_awards
      get 'awards/:id/edit' => 'awards#edit', as: :edit_award
      post 'awards/:id/update' => 'awards#update', as: :update_award
      post 'awards/:id/delete' => 'awards#delete', as: :delete_award

      resource :users, only: [:new, :create]
      get 'users' => 'users#index', as: :index_users
      get 'users/:id/edit' => 'users#edit', as: :edit_user
      post 'users/:id/update' => 'users#update', as: :update_user
      post 'users/:id/delete' => 'users#delete', as: :delete_user

      resource :animes, only: [:new, :create]
      get 'animes' => 'animes#index', as: :index_animes
      get 'animes/:id/edit' => 'animes#edit', as: :edit_anime
      post 'animes/:id/update' => 'animes#update', as: :update_anime
      post 'animes/:id/delete' => 'animes#delete', as: :delete_anime

      post 'candidates' => 'candidates#create', as: :create_candidate
      post 'candidates/:id/delete' => 'candidates#delete', as: :delete_candidate
    end
  end

  get '/animes', to: 'animes#index', as: :index_animes
  get 'vote/:id', to: 'ballots#show', as: :vote_on_ballot
  post 'vote_candidate/:ballot_id/:a_or_b', to: 'ballots#vote_candidate', as: :vote_candidate

  get 'finished_voting', to: 'pages#finished_voting', as: :finished_voting

  # Clearance Routes:
  #
  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  resources :users, controller: 'clearance/users', only: [:create] do
    resource :password,
             controller: 'clearance/passwords',
             only: [:create, :edit, :update]
  end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'clearance/users#new', as: 'sign_up'
end
