Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#home'

  resource :animes, only: [:new, :create, :show]
  get 'animes/all', to: 'animes#index'

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
