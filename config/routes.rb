Rails.application.routes.draw do
  get 'new', to: 'games#new'
  get 'score', to: 'games#score'
  post 'score', to: 'games#score'

  root to: 'games#new'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
