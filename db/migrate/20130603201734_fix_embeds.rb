class FixEmbeds < ActiveRecord::Migration
  def up
	  change_column :avatars, :pov_stream_embed, :text
  	change_column :places, :fix_stream_embed, :text
  end

  def down
  	change_column :avatars, :pov_stream_embed, :string
  	change_column :places, :fix_stream_embed, :string
  end
end
