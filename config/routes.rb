LinkedinSignIn::Engine.routes.draw do
  get '/sign_in', to: 'sign_in#show'
  get '/callback', to: 'callbacks#show'
end
