Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#home'

  resource :animes, only: [:new, :create, :show]
  get 'animes/all', to: 'animes#index'

  get 'vote/:id', to: 'ballots#show', as: :vote_on_ballot
  post 'vote_candidate/:ballot_id/:a_or_b', to: 'ballots#vote_candidate', as: :vote_candidate

  get 'finished_voting', to: 'pages#finished_voting', as: :finished_voting
end
