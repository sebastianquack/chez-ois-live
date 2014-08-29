class Suggestion < ActiveRecord::Base
  attr_accessible :content, :avatar_id, :ip_address, :name, :name2, :user_hash, :score, :status, :time_string, :voting_started_at
  has_many :user_votes
  belongs_to :avatar
  
  def as_json(options={}) 
  	{
  		:id => id,
  		:ip => ip_address,
  		:content => content,
  		:name => name,
  		:name2 => name2,
  		:vote_time => voting_started_at,
  		:time => time_string,
	  	:score => score,
	  	:status => status
  	}
  end
  
end
