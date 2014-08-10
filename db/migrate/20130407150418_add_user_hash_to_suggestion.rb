class AddUserHashToSuggestion < ActiveRecord::Migration
  def up
  	add_column :suggestions, :user_hash, :string
  end
  
  def down
  	remove_column :suggestions, :user_hash
  end
end
