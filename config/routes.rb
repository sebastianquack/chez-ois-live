AvatarChat::Application.routes.draw do

  resources :settings
  resources :places

	match '/avatars/list' => 'avatars#list'
  resources :avatars

	match '/chat_items/submit' => 'chat_items#submit'
	match '/chat_items/latest' => 'chat_items#latest'

	match '/suggestions/list' => 'suggestions#list'
	match '/suggestions/submit' => 'suggestions#submit'

	match '/suggestions/:id/vote' => 'suggestions#vote'
	match '/suggestions/:id/start_vote' => 'suggestions#start_vote'
	match '/suggestions/:id/retire' => 'suggestions#retire'
	match '/suggestions/:id/accept' => 'suggestions#accept'
	match '/suggestions/:id/decline' => 'suggestions#decline'

	match '/suggestions/global_highscores' => 'suggestions#global_highscores'
	match '/suggestions/highscores' => 'suggestions#highscores'
	match '/suggestions/clear_highscores' => 'suggestions#clear_highscores'
	match '/suggestions/update_user_name' => 'suggestions#update_user_name'

  match '/admin/blacklist' => 'admin#blacklist'
  match '/admin/block' => 'admin#block'
  match '/admin/boost' => 'admin#boost'
  match '/admin/reset' => 'admin#reset'
  match '/admin/delete_suggestions' => 'admin#delete_suggestions'
  
  match '/displays/projection' => 'displays#projection'
  match '/displays/projection2' => 'displays#projection2'

	match '/displays/hd' => 'displays#hd'
	match '/displays/hd2' => 'displays#hd2'

	match '/play' => 'home#play'  
	match '/avatar' => 'home#terminal'
	match '/terminal' => 'home#terminal'

	match '/chat' => 'home#chat'  
  match '/pov' => 'home#pov'  
  match '/highscores' => 'home#highscores'  

  match '/moderate' => 'home#moderate'
  match '/notice' => 'chat_items#latest'
  match '/notice/submit' => 'chat_items#submit'
  
  match '/test' => 'home#test'
  
  root :to => 'home#landing'

end