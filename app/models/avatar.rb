class Avatar < ActiveRecord::Base
  #attr_accessible :name, :gender, :pov_stream_embed, :pov_stream_embed_local, :place_id, :pushover_user_key
  belongs_to :place
end
