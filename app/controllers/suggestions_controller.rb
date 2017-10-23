require 'pushover'

class SuggestionsController < ApplicationController

  # get the current list of suggestions
	def load_suggestions(avatar_id)

    # get the top sugestions
    @suggestions_top = Suggestion.where("status = 1 AND avatar_id = :avatar_id AND voting_started_at < :limit", :avatar_id => avatar_id, :limit => 1.minute.ago).order("score DESC, voting_started_at ASC").limit(Setting.first.num_display_suggestions - 1)
    
    # see if there is a suggestion in transmit that has been read
    @suggestion_transmit = Suggestion.where("status = 3 AND avatar_id = :avatar_id AND voting_started_at < :limit", :avatar_id => avatar_id, :limit => 10.seconds.ago).order("voting_started_at DESC").first

    # if there is only one suggestion - and none is currently being transmitted
    if @suggestions_top.length > 0 && @suggestion_transmit == nil
      if @suggestions_top[0].score >= 0
        logger.debug "direct to transmit"
        accept_suggestion(@suggestions_top[0])
        @suggestion_transmit = @suggestions_top[0]
        @suggestions_top = @suggestions_top.to_a
        @suggestions_top.shift
      end
    end      
    
    @suggestions_top.each do |suggestion|
  		logger.debug suggestion.score.to_s + ' ' + suggestion.content
    end
    
    @user_votes_top = Hash.new
		@suggestions_top.each do |suggestion| 
			@user_votes_top[suggestion.id] = suggestion.user_votes
		end
		
		#@suggestions_accepted = Suggestion.where(:status => '1', :avatar_id => avatar_id).order("updated_at DESC").limit(1)

    logger.debug "loading top suggestions: " + @suggestions_top.inspect
    logger.debug "loading transmit suggestion: " + @suggestion_transmit.inspect

		return {
        :suggestion_transmit => @suggestion_transmit,
				:suggestions_top => @suggestions_top,
				:user_votes_top => @user_votes_top,
				:now => Time.now.to_i
			}	
	end

  # STEP 0 - a user watches current suggestions

  def list
		# see also as_json overrides in the models
		render json: load_suggestions(suggestion_params[:avatar_id])		 
  end

  # special mode for avatar list
  def avatar_list
    @suggestions = Suggestion.where(:status => '0').order("score DESC, created_at DESC").limit(5)
		render :partial => 'suggestions/avatar_list'
  end

  # STEP 1 - a user submits a new suggestion

	def submit
    
    # check if user is blacklisted
		blacklist_entry = IpBlacklist.find_by_ip_address(request.remote_ip)
		if blacklist_entry
			if blacklist_entry.status == 0
				render json: {:status => "blacklisted", :name => blacklist_entry.user_name}
				return
      elsif blacklist_entry.status == 2
        @boost = true
      elsif blacklist_entry.status == 3
        @solo = true
      end
		end
        
    # check if someone is soloing
    solo_entry = IpBlacklist.find_by_status(3)
    if solo_entry
      if solo_entry.ip_address != request.remote_ip
        render json: {:status => "solo", :name => solo_entry.user_name}
        return
      end
    end
      
    # create a new suggestion
		@suggestion = Suggestion.new(
				:time_string => Time.now.to_i,
        :voting_started_at => Time.now.to_i,
				:content => suggestion_params[:content], 
				:name => suggestion_params[:name],
				:avatar_id => suggestion_params[:avatar_id],
				:user_hash => cookies['user_hash'],
				:score => 0,
				:status => 1, # go directly to voting
				:ip_address => request.remote_ip
		)        

    if suggestion_params[:name] == ""
      @suggestion.name = "Gast"
    end

    if @boost # boost, go directly to transmit
      boost_suggestion(@suggestion)
		end

    if @solo 
      @suggestion.name2 = "solo"
    end

		if @suggestion.save
      Pusher.trigger('chez_ois_chat', 'update_suggestions_' + suggestion_params[:avatar_id], load_suggestions(suggestion_params[:avatar_id]))
      #Pusher['chez_ois_chat'].trigger('update_suggestions_' + suggestion_params[:avatar_id], load_suggestions(params[:avatar_id]))
      if @boost
        render json: {:status => "boost"}
      else
			  render json: @suggestion
      end
  	end
  end

  # STEP 2 - a suggestion reaches the top of the list and become a transmit suggestion

  def accept_suggestion(suggestion)
    if suggestion.status != 3 # do this only if it hasn't been done
      suggestion.status = 3
      suggestion.voting_started_at = Time.now.to_i # update timestamp for transmit time   
      suggestion.save
      read_suggestion(suggestion)
    end
  end
    
	def accept
		@suggestion = Suggestion.find(params[:id])
    if @suggestion.status != 3 # do this only if it hasn't been done
      accept_suggestion(@suggestion)
      #Pusher['chez_ois_chat'].trigger('read_message', { :message => "Vorschlag angenommen: " + @suggestion.content })
      #Pusher['chez_ois_chat'].trigger('update_highscores', load_highscores)
    end

		render json: @suggestion
	end

  # read a suggestion out loud

  def read_suggestion(suggestion)
    if !suggestion.read # read only once
      speech_output = suggestion.name + ' ' + Setting.first.local_text_to_speach_says + ': ' + suggestion.content
      speech_output_watch = suggestion.name + ': ' + suggestion.content
      logger.debug "reading " + speech_output

      Pusher['chez_ois_chat'].trigger('read_suggestions', {:avatar_id => params[:avatar_id], :content => speech_output})
      suggestion.read = true
      suggestion.save
      
      #url = URI.parse("https://api.pushover.net/1/messages.json")
      #req = Net::HTTP::Post.new(url.path)
      #req.set_form_data({
      #  :token => ENV['chez_ois_pushover_app_token'],
      #  :user => suggestion.avatar.pushover_user_key,
      #  :message => speech_output_watch,
      #  })
      #  res = Net::HTTP.new(url.host, url.port)
      #  res.use_ssl = true
      #  res.verify_mode = OpenSSL::SSL::VERIFY_PEER
      #  res.start {|http| http.request(req) }
      Pushover.notification(message: speech_output_watch, title: 'message', user: suggestion.avatar.pushover_user_key, token:  ENV['chez_ois_pushover_app_token'])

    end
  end

  # STEP 3 - a suggestions time has run out

  def retire_suggestion(suggestion, params)
    if suggestion.status != 2
		  logger.debug 'RETIRE'
			suggestion.status = 2
      suggestion.save		  
      Pusher['chez_ois_chat'].trigger('update_suggestions_' + suggestion_params[:avatar_id], load_suggestions(suggestion_params[:avatar_id]))
    end
  end

	def retire
    suggestion = Suggestion.find(params[:id])
    retire_suggestion(suggestion, params)
    render json: suggestion	
	end

  # VOTING a user votes on one of the suggestions

	def vote 
		suggestion = Suggestion.find(suggestion_params[:id])
		user_vote = UserVote.where({
				:user_hash => cookies[:user_hash],
				:suggestion_id => suggestion.id}).first
		
		if suggestion_params[:abort]

			now = Time.now.to_i
			if now < (suggestion.voting_started_at.to_i + 55)
				suggestion.voting_started_at = now - 55
			end
      
    else

			if user_vote # the user has already voted on this
				logger.debug 'vote exists'
				if suggestion_params[:direction] == 'up' && user_vote.vote < 1
					user_vote.vote += 1
					suggestion.score += 1
					#user_reward(suggestion, 2)
				elsif suggestion_params[:direction] == 'down' && user_vote.vote > -1
					user_vote.vote -= 1
					suggestion.score -= 1
					#user_reward(suggestion, -2)
				end
				
			else # the user votes on this for the first time
				logger.debug 'new vote'
				if suggestion_params[:direction] == 'up' 
					suggestion.score += 1
					#user_reward(suggestion, 1)
					v = 1
				else 
					suggestion.score -= 1
					#user_reward(suggestion, -1)
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
		

		if suggestion_params[:top_boost]
				suggestion.name2 = cookies[:user_name]
		end
								
		suggestion.save

		Pusher['chez_ois_chat'].trigger('update_suggestions_' + suggestion_params[:avatar_id], load_suggestions(suggestion_params[:avatar_id]))
		#Pusher['chez_ois_chat'].trigger('update_highscores', load_highscores)
		render json: suggestion
	end
    
  # USER OPERATIONS

	def update_user_name 
		cookies.permanent[:user_name] = user_params[:name]		
		user = UserScore.find_by_user_hash(cookies['user_hash'])
		if(user)
			if(user.user_name != user_params[:name]) 
				user.user_name = user_params[:name]
				user.save
			end
		end
		render json: user
	end
		
	def user_reward(suggestion, amount)
		unless suggestion_params[:avatar_id] 
			return
		end
		if(suggestion.user_hash == cookies[:user_hash]) #prevent scoring on your own suggestions
			return
    end
		user_score = UserScore.find(:first, :conditions => {
				:user_hash => suggestion.user_hash,
				:avatar_id => suggestion_params[:avatar_id]
		})
		unless user_score 
			user_score = UserScore.new(
				:user_hash => suggestion.user_hash,
				:user_name => suggestion.name,
				:avatar_id => suggestion_params[:avatar_id],
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

  # HIGHSCORES

	def load_highscores 	
			user_highscores = UserScore.order("score DESC").limit(10)			
      suggestion_highscores = Suggestion.where("score > 0").order("score DESC, created_at ASC").limit(10)
      return { :user_highscores => user_highscores, :suggestion_highscores => suggestion_highscores }
  end
	def highscores
		# see also as_json overrides in the models
		render json: load_highscores
	end
	  
  # ADMIN Operations
  
  # the admin removes a suggestion
  def decline_suggestion suggestion 
		suggestion.status = 4	
		suggestion.save
		#user_reward(suggestion, -5)
  end

	def decline
		@suggestion = Suggestion.find(params[:id])
    decline_suggestion @suggestion
		Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
		Pusher['chez_ois_chat'].trigger('update_highscores', load_highscores)    
		render json: @suggestion
	end
    
	def load_blacklist
		@blocked_ip_adresses = IpBlacklist.where("status != 1").order('status DESC')
    return {:blacklist => @blocked_ip_adresses }	
	end

	def blacklist
		render json: load_blacklist
	end

  def set_blacklist_status ip, name, status
		blocked_ip = IpBlacklist.find_by_ip_address(ip)
		if blocked_ip 
			blocked_ip.status = status
			blocked_ip.user_name = name
		else
			blocked_ip = IpBlacklist.new(
				:ip_address => ip,
				:user_name => name,
				:status => status
				)
		end
		blocked_ip.save
		Pusher['chez_ois_chat'].trigger('update_blacklist', load_blacklist)
    return blocked_ip
	end

	def block
    set_blacklist_status(params[:ip], params[:name], 0)
    suggestions = Suggestion.where(:ip_address => suggestion_params[:ip]).update_all status: 4
    Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
		Pusher['chez_ois_chat'].trigger('update_highscores', load_highscores)    

    render json: :ok
  end

  def boost_suggestion suggestion
    # get current transmit suggestion and retire
    suggestion_transmit = Suggestion.where("status = 3 AND avatar_id = :avatar_id AND voting_started_at < :limit", :avatar_id => params[:avatar_id], :limit => 10.seconds.ago).order("voting_started_at DESC").first
    retire_suggestion(suggestion_transmit) if suggestion_transmit
    suggestion.name2 = "boost"
    suggestion.status = 3
    read_suggestion(suggestion)
  end

	def boost
    set_blacklist_status(params[:ip], params[:name], 2)
    suggestion = Suggestion.find(params[:suggestion_id])
    boost_suggestion suggestion
    Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
    render json: :ok
  end

	def solo
    set_blacklist_status(params[:ip], params[:name], 3)
    suggestions = Suggestion.where(
      "ip_address = :ip_address AND voting_started_at < :limit", :ip_address => params[:ip], :limit => 1.minute.ago
      ).update_all :name2 => "solo"
    Pusher['chez_ois_chat'].trigger('update_suggestions_' + params[:avatar_id], load_suggestions(params[:avatar_id]))
    render json: :ok
  end

	def reset
		blocked_ip = IpBlacklist.find_by_ip_address(params[:ip])
		blocked_ip.status = 1
		blocked_ip.save
		Pusher['chez_ois_chat'].trigger('update_blacklist', load_blacklist)
		render json: blocked_ip
	end
  
	def clear_highscores
    UserScore.destroy_all
    Suggestion.update_all score: 0
    
		Pusher['chez_ois_chat'].trigger('update_highscores', load_highscores)
		render json: load_highscores
	end

  private

  def suggestion_params
    params.permit(:content, :avatar_id, :ip_address, :name, :name2, :user_hash, :score, :status, :time_string, :voting_started_at, :id, :direction)
  end

  def user_params
    params.permit(:name, :avatar_id)
  end
  

end
