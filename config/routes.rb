Rails.application.routes.draw do

  get 'pages/connect'

  get 'pages/howto'
  get 'pages/data'
  get 'pages/index'

  root 'pages#index'

  get 'messages/reply'
  resource :messages do
  	collection do
  		post 'reply'
  	end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
