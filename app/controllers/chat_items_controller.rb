class ChatItemsController < ApplicationController

  def latest
		@chat_item = ChatItem.order("created_at").last
  end

	def submit    
    # create a new chat_iteam
		@chat_item = ChatItem.new(
				:content => params[:content], 
				:ip_address => request.remote_ip
		)        
		if @chat_item.save
      Pusher.trigger('chez_ois_chat', 'update_notice', {:content => params[:content]})
			render json: @chat_item
  	end
  end

end
