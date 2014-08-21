class SuggestionsController < ApplicationController

	def load_suggestions(avatar_id)

		@suggestions_new = Suggestion.where("status != 4 AND avatar_id = :avatar_id AND created_at > :limit", {:avatar_id => avatar_id, :limit => Time.now - 10.minutes}).order("created_at DESC").limit(17)
		@suggestions_new.reverse!

    @user_votes_new = Hash.new
		@suggestions_new.each do |suggestion| 
			@user_votes_new[suggestion.id] = suggestion.user_votes
		end
	
    @suggestions_top = Suggestion.where("status = 1 AND read = 'false' AND avatar_id = :avatar_id AND voting_started_at < :limit", :avatar_id => avatar_id, :limit => 1.minute.ago).order("score DESC, voting_started_at ASC").limit(4)
    @suggestion_transmit = Suggestion.where("status = 3 AND read = 'true' AND avatar_id = :avatar_id AND voting_started_at < :limit", :avatar_id => avatar_id, :limit => 10.seconds.ago).order("voting_started_at ASC").first

    logger.debug @suggestions_top
    logger.debug @suggestion_transmit

    # if there is only one suggestion - and none is currently being transmitted
    if @suggestions_top.length > 0 && @suggestion_transmit == nil
      logger.debug "direct to transmit"
      accept_suggestion(@suggestions_top[0])
      @suggestion_transmit = @suggestions_top[0]
      @suggestions_top.shift
    end      
    
    @suggestions_top.each do |suggestion|
  		logger.debug suggestion.score.to_s + ' ' + suggestion.content
    end
    
    @user_votes_top = Hash.new
		@suggestions_top.each do |suggestion| 
			@user_votes_top[suggestion.id] = suggestion.user_votes
		end
		
		#@suggestions_accepted = Suggestion.where(:status => '1', :avatar_id => avatar_id).order("updated_at DESC").limit(1)

		return {
        :suggestion_transmit => @suggestion_transmit,
				#:suggestions_new => @suggestions_new,
				:user_votes_new => @user_votes_new,
				:suggestions_top => @suggestions_top,
				:user_votes_top => @user_votes_top,
				:now => Time.now.to_i
				#:suggestions_accepted => @suggestions_accepted
			}	
	end

  def list
		# see also as_json overrides in the models
		render json: load_suggestions(params[:avatar_id])		 
  end

	def submit
		blacklist_entry = IpBlacklist.find_by_ip_address(request.remote_ip)
		if blacklist_entry
			if blacklist_entry.status == 0
				render json: :blacklisted
				return
			end
		end
		@suggestion = Suggestion.new(
				:time_string => Time.now.to_i,
        :voting_started_at => Time.now.to_i,
				:content => params[:content], 
				:name => params[:name],
				:avatar_id => params[:avatar_id],
				:user_hash => cookies['user_hash'],
				:score => 0,
				:status => 1, # go directly to voting
				:ip_address => request.remote_ip
		)
        
		if @suggestion.save
			Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
			render json: @suggestion
  	end
  end

	def update_user_name 
		cookies.permanent[:user_name] = params[:name]		
		user = UserScore.find_by_user_hash(cookies['user_hash'])
		if(user)
			if(user.user_name != params[:name]) 
				user.user_name = params[:name]
				user.save
			end
		end
		render json: user
	end
		
	def user_reward(suggestion, amount)
		unless params[:avatar_id] 
			return
		end
		if(suggestion.user_hash == cookies[:user_hash]) #prevent scoring on your own suggestions
			return
		end
		user_score = UserScore.find(:first, :conditions => {
				:user_hash => suggestion.user_hash,
				:avatar_id => params[:avatar_id]
		})
		unless user_score 
			user_score = UserScore.new(
				:user_hash => suggestion.user_hash,
				:user_name => suggestion.name,
				:avatar_id => params[:avatar_id],
				:score => 0
			)
		end
		if (user_score.score + amount) >= 0 
			user_score.score += amount
		else 
			user_score.score = 0
		end
		user_score.save
	end

	def start_vote
		suggestion = Suggestion.find(params[:id])
		suggestion.status = 1
		suggestion.voting_started_at = Time.now.to_i
		suggestion.save
		Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
		render json: suggestion
	end

	def retire
		suggestion = Suggestion.find(params[:id])

    if suggestion.status != 2
		  logger.debug 'RETIRE'
			suggestion.status = 2
      suggestion.save		
      Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
    end
		
		render json: suggestion	
	end

	def vote 
		suggestion = Suggestion.find(params[:id])
		user_vote = UserVote.find(:first, :conditions => {
				:user_hash => cookies[:user_hash],
				:suggestion_id => suggestion.id
		})
		
		if params[:abort]

			now = Time.now.to_i
			if now < (suggestion.voting_started_at.to_i + 55)
				suggestion.voting_started_at = now - 55
			end
      
    else

			if user_vote # the user has already voted on this
				logger.debug 'vote exists'
				if params[:direction] == 'up' && user_vote.vote < 1
					user_vote.vote += 2
					suggestion.score += 2
					user_reward(suggestion, 2)
				elsif params[:direction] == 'down' && user_vote.vote > -1
					user_vote.vote -= 2
					suggestion.score -= 2
					user_reward(suggestion, -2)
				end
				
			else # the user votes on this for the first time
				logger.debug 'new vote'
				if params[:direction] == 'up' 
					suggestion.score += 1
					user_reward(suggestion, 1)
					v = 1
				else 
					suggestion.score -= 1
					user_reward(suggestion, -1)
					v = -1
				end
				user_vote = UserVote.new(
					:user_hash => cookies[:user_hash],
					:suggestion_id => suggestion.id,
					:vote => v
				)
			end
			
			user_vote.save						
		
		end			
		

		if params[:top_boost]
				suggestion.name2 = cookies[:user_name]
		end
								
		suggestion.save

		Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
		Pusher['chez_ois_chat'].trigger('update_highscores', load_highscores)
		render json: suggestion
	end

  def avatar_list
    @suggestions = Suggestion.where(:status => '0').order("score DESC, created_at DESC").limit(5)
		render :partial => 'suggestions/avatar_list'
  end
	
  def accept_suggestion(suggestion)
		suggestion.status = 3
		suggestion.save
    read_suggestion(suggestion)
		user_reward(suggestion, 5)
  end
    
	def accept
		@suggestion = Suggestion.find(params[:id])
    accept_suggestion(@suggestion)
		
		Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
		#Pusher['chez_ois_chat'].trigger('read_message', { :message => "Vorschlag angenommen: " + @suggestion.content })
		Pusher['chez_ois_chat'].trigger('update_highscores', load_highscores)

		render json: @suggestion
	end

  def read_suggestion(suggestion)
		speech_output = suggestion.name + ' sagt: ' + suggestion.content
    speech_output_watch = suggestion.name + ': ' + suggestion.content
    Pusher['chez_ois_chat'].trigger('read_suggestions', {:avatar_id => params[:avatar_id], :content => speech_output})
    suggestion.read = true
		suggestion.voting_started_at = Time.now.to_i    
    suggestion.save
    
    url = URI.parse("https://api.pushover.net/1/messages.json")
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({
      :token => ENV['chez_ois_pushover_app_token'],
      :user => suggestion.avatar.pushover_user_key,
      :message => speech_output_watch,
    })
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_PEER
    res.start {|http| http.request(req) }
    
    
  end

	def decline
		@suggestion = Suggestion.find(params[:id])
		@suggestion.status = 4	
		@suggestion.save

		user_reward(@suggestion, -5)

		Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
		#Pusher['chez_ois_chat'].trigger('read_message', { :message => "Vorschlag abgelehnt: " + @suggestion.content })
		Pusher['chez_ois_chat'].trigger('update_highscores', load_highscores)

		render json: @suggestion
	end

	def load_global_highscores
			global_highscores = Suggestion.order("score DESC").limit(10)
			return { :global_highscores => global_highscores }
	end
	def global_highscores
			render json: load_global_highscores
	end

	def load_highscores 	
			unless params[:avatar_id] 
				return {} 
			end
			highscores = UserScore.where({
				:avatar_id => params[:avatar_id]
			}).order("score DESC").limit(10)
			return { :highscores => highscores }
  end
	def highscores
		# see also as_json overrides in the models
		render json: load_highscores
	end
	
	def clear_highscores
		UserScore.destroy_all(:avatar_id => params[:avatar_id])
		Pusher['chez_ois_chat'].trigger('update_highscores', load_highscores)
		render json: load_highscores
	end

end
