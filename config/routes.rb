Rails.application.routes.draw do
  get 'messages/reply'
  resource :messages do
  	collection do
  		post 'reply'
  	end
  end
  post 'twilio/voice' => 'twilio#voice'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
