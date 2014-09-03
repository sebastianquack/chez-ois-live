class ChatItem < ActiveRecord::Base
  attr_accessible :content, :name, :ip_address
  
  def as_json(options={}) 
  	{
  		:ip => ip_address,
  		:name => name,
  		:content => content,
  	}
  end
  
end
