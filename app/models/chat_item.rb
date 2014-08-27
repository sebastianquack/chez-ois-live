class ChatItem < ActiveRecord::Base
  attr_accessible :content, :ip_address
  
  def as_json(options={}) 
  	{
  		:ip => ip_address,
  		:content => content,
  	}
  end
  
end
