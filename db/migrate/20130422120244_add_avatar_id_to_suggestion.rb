class AddAvatarIdToSuggestion < ActiveRecord::Migration
  def up
  	add_column :suggestions, :avatar_id, :integer
  end
  
  def down
  	remove_column :suggestions, :avatar_id
  end
end
