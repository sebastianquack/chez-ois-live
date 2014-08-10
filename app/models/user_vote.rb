class UserVote < ActiveRecord::Base
  attr_accessible :suggestion_id, :user_hash, :vote
  belongs_to :suggestion
  
  def as_json(options={}) 
  	{
  		:user => user_hash,
	  	:vote => vote
  	}
  end
end
