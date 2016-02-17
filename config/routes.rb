AvatarChat::Application.routes.draw do

  resources :settings
  resources :places

	get '/avatars/list' => 'avatars#list'
  resources :avatars

	#post '/chat_items/submit' => 'chat_items#submit'
	#get '/chat_items/latest' => 'chat_items#latest'

	get '/suggestions/list' => 'suggestions#list'
	post '/suggestions/submit' => 'suggestions#submit'

	post '/suggestions/:id/vote' => 'suggestions#vote'
	post '/suggestions/:id/start_vote' => 'suggestions#start_vote'
	post '/suggestions/:id/retire' => 'suggestions#retire'
	post '/suggestions/:id/accept' => 'suggestions#accept'
	post '/suggestions/:id/decline' => 'suggestions#decline'

	get '/suggestions/global_highscores' => 'suggestions#global_highscores'
	get '/suggestions/highscores' => 'suggestions#highscores'
	post '/suggestions/clear_highscores' => 'suggestions#clear_highscores'
	post '/suggestions/update_user_name' => 'suggestions#update_user_name'

  get '/admin/blacklist' => 'suggestions#blacklist'
  post '/admin/block' => 'suggestions#block'
  post '/admin/boost' => 'suggestions#boost'
  post '/admin/solo' => 'suggestions#solo'
  post '/admin/reset' => 'suggestions#reset'
  post '/admin/delete_suggestions' => 'admin#delete_suggestions'
  
  #get '/displays/projection' => 'displays#projection'
  #get '/displays/projection2' => 'displays#projection2'

	#get '/displays/hd' => 'displays#hd'
	#get '/displays/hd2' => 'displays#hd2'

	#get '/play' => 'home#play'  
	#get '/avatar' => 'home#terminal'
	#get '/terminal' => 'home#terminal'

  get '/chat' => 'home#chat'  
  #get '/pov' => 'home#pov'  
  #get '/highscores' => 'home#highscores'  

  get '/moderate' => 'home#moderate'
  get '/notice' => 'chat_items#latest'
  post '/notice/submit' => 'chat_items#submit'
  
  #get '/test' => 'home#test'
  
  get '/log' => 'home#log'
  
  root :to => 'home#chat'

end
