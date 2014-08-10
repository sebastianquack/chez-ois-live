class AddLocalEmbedToPlace < ActiveRecord::Migration
  def change
  	add_column :places, :fix_stream_embed_local, :text
  end
end
