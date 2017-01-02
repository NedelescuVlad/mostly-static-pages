Rails.application.routes.draw do
  root 'static_pages#home'

	# Static Pages
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help', as: 'helf'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

	# Signup
  get '/signup', to: 'users#new', as: 'signup'
	post 'signup', to: 'users#create'

	# Authentication
	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'

	resources :users
end
