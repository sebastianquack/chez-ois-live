class AddLocalEmbedToAvatar < ActiveRecord::Migration
  def change
  	add_column :avatars, :pov_stream_embed_local, :text
  end
end
