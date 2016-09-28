Rails.application.routes.draw do
  root 'main#index'

  post '/', to: 'main#listen'
end
