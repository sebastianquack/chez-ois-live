class Place < ActiveRecord::Base
  #attr_accessible :fix_stream_embed, :fix_stream_embed_local, :name
  has_many :avatars
end
