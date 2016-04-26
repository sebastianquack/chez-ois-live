AvatarChat::Application.routes.draw do

  resources :settings
  resources :places

	get '/avatars/list' => 'avatars#list'
  resources :avatars

  # user actions on suggestions
	get '/suggestions/list' => 'suggestions#list'
	post '/suggestions/submit' => 'suggestions#submit'
	post '/suggestions/:id/vote' => 'suggestions#vote'
	post '/suggestions/:id/start_vote' => 'suggestions#start_vote'
	post '/suggestions/:id/retire' => 'suggestions#retire'
	post '/suggestions/:id/accept' => 'suggestions#accept'
	post '/suggestions/:id/decline' => 'suggestions#decline'

  # user actions on user name  
  post '/suggestions/update_user_name' => 'suggestions#update_user_name'

  # moderator actions
  get '/admin/blacklist' => 'suggestions#blacklist'
  post '/admin/block' => 'suggestions#block'
  post '/admin/boost' => 'suggestions#boost'
  post '/admin/solo' => 'suggestions#solo'
  post '/admin/reset' => 'suggestions#reset'
  post '/admin/delete_suggestions' => 'admin#delete_suggestions'

  # moderator interface
  get '/moderate' => 'home#moderate'
  post '/notice/submit' => 'chat_items#submit'
  get '/log' => 'home#log'
  
  # public user interface, used in iframe
  get '/chat' => 'home#chat'  
  get '/notice' => 'chat_items#latest' # deprecated, to be included in chat
  
  root :to => 'home#chat'

end
