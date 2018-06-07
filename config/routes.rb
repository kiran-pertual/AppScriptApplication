Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "oauth#auth"

  get '/auth', to: "oauth#auth"
end
