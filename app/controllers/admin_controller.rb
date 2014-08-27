class AdminController < ApplicationController

 	#before_filter :authenticate
	
	def delete_suggestions
		Suggestion.delete_all()
		UserVote.delete_all()
		UserScore.delete_all()
		render json: 'ok'
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
    render json: set_blacklist_status(params[:ip], params[:name], 0)
  end

	def boost
    render json: set_blacklist_status(params[:ip], params[:name], 2)
  end

	def reset
		blocked_ip = IpBlacklist.find_by_ip_address(params[:ip])
		blocked_ip.status = 1
		blocked_ip.save
		Pusher['chez_ois_chat'].trigger('update_blacklist', load_blacklist)
		render json: blocked_ip
	end


end
