class Avatar < ActiveRecord::Base
  attr_accessible :name, :pov_stream_embed, :pov_stream_embed_local, :place_id
  belongs_to :place
end
