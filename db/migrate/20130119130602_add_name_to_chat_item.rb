class AddNameToChatItem < ActiveRecord::Migration
  def up
  	add_column :chat_items, :name, :string
  end
  
  def down
  	remove_column :chat_items, :name
  end
end
