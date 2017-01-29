Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#home'

  resource :animes, only: [:new, :create, :show]
  get 'animes/all', to: 'animes#index'

  get 'vote/:id', to: 'ballots#show'
  post 'vote_candidate_a/:id', to: 'ballots#vote_candidate_a', as: :vote_candidate_a
  post 'vote_candidate_b/:id', to: 'ballots#vote_candidate_b', as: :vote_candidate_b

  get 'finished_voting', to: 'pages#finished_voting', as: :finished_voting
end
