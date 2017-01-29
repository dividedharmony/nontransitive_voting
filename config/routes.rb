Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :animes, only: [:new, :create, :show]
  get 'animes/all', to: 'animes#index'
end
