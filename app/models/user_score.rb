class UserScore < ActiveRecord::Base
  attr_accessible :user_hash, :user_name, :avatar_id, :score

  def as_json(options={}) 
  	{
  		:user_name => user_name,
	  	:score => score
  	}
  end

end
