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
  
#
#suggestion status:
#start: 0
#voting: 1
#time_up: 2
#time_up_first_place: 3
#accepted: 4 
#declined: 5
  
#  if Rails.env.development?  
 # scope :with_rank, select('suggestions.*')
#  	.select("(1.0 / ( (strftime('%s','now') - strftime('%s',suggestions.created_at)) / 30.0) + suggestions.score) as rank")
#  	.where('suggestions.status = 0 and suggestions.score > 0')
#    .order('rank DESC')
#	end

#	if Rails.env.production?
#  scope :with_rank, select('suggestions.*')
#  	.select("(1.0 / ( (EXTRACT(EPOCH FROM now()) - EXTRACT(EPOCH FROM suggestions.created_at)) / 30.0) + (suggestions.score - 1.0) * 15.0) as rank")
#  	.where('suggestions.status = 1 and (EXTRACT(EPOCH FROM now()) - EXTRACT(EPOCH FROM suggestions.created_at)) < 240.0')
#    .order('rank DESC')
#	end

end
