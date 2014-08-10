AvatarChat::Application.routes.draw do

  resources :settings
  resources :places

	match '/avatars/list' => 'avatars#list'
  resources :avatars

	match '/chat_items/submit' => 'chat_items#submit'
	match '/chat_items/list' => 'chat_items#list'
	match '/suggestions/list' => 'suggestions#list'
	match '/suggestions/submit' => 'suggestions#submit'

	match '/suggestions/:id/vote' => 'suggestions#vote'
	match '/suggestions/:id/start_vote' => 'suggestions#start_vote'
	match '/suggestions/:id/retire2' => 'suggestions#retire'
	match '/suggestions/:id/accept' => 'suggestions#accept'
	match '/suggestions/:id/decline' => 'suggestions#decline'

	match '/suggestions/global_highscores' => 'suggestions#global_highscores'
	match '/suggestions/highscores' => 'suggestions#highscores'
	match '/suggestions/clear_highscores' => 'suggestions#clear_highscores'
	match '/suggestions/update_user_name' => 'suggestions#update_user_name'

  match '/admin/blacklist' => 'admin#blacklist'
  match '/admin/block' => 'admin#block'
  match '/admin/unblock' => 'admin#unblock'
  match '/admin/delete_suggestions' => 'admin#delete_suggestions'
  
  match '/displays/projection' => 'displays#projection'
  match '/displays/projection2' => 'displays#projection2'

	match '/displays/hd' => 'displays#hd'
	match '/displays/hd2' => 'displays#hd2'

	match '/play' => 'home#play'  
	match '/avatar' => 'home#terminal'
	match '/terminal' => 'home#terminal'
	
  root :to => 'home#landing'

end
