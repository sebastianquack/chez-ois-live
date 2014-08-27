class AdminController < ApplicationController

 	#before_filter :authenticate
	
	def delete_suggestions
		Suggestion.delete_all()
		UserVote.delete_all()
		UserScore.delete_all()
		render json: 'ok'
	end
	
	def load_blacklist
		@blocked_ip_adresses = IpBlacklist.where(:status => 0)
		return {:blacklist => @blocked_ip_adresses }	
	end

	def blacklist
		render json: load_blacklist
	end

	def block
		blocked_ip = IpBlacklist.find_by_ip_address(params[:ip])
		if blocked_ip 
			blocked_ip.status = 0
			blocked_ip.user_name = params[:name]
		else
			blocked_ip = IpBlacklist.new(
				:ip_address => params[:ip],
				:user_name => params[:name],
				:status => 0
				)
		end
		blocked_ip.save
		Pusher['chez_ois_chat'].trigger('update_blacklist', load_blacklist)
		render json: blocked_ip
	end

	def unblock
		blocked_ip = IpBlacklist.find_by_ip_address(params[:ip])
		blocked_ip.status = 1
		blocked_ip.save
		Pusher['chez_ois_chat'].trigger('update_blacklist', load_blacklist)
		render json: blocked_ip
	end

end
