class ChatItemsController < ApplicationController

  def latest
		@chat_item = ChatItem.order("created_at").last
  end

	def submit    
    # create a new chat_iteam
		@chat_item = ChatItem.new(
				:content => chat_item_params[:content], 
				:name => chat_item_params[:name],
        :ip_address => request.remote_ip
		)        
		if @chat_item.save
      Pusher.trigger('chez_ois_chat', 'update_notice', {:name => chat_item_params[:name], :content => chat_item_params[:content]})
			render json: @chat_item
  	end
  end

  private

  def chat_item_params
    params.permit(:content, :name, :ip_address)
  end


end
