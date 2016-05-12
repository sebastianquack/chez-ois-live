class AddInputPlaceholderToAvatar < ActiveRecord::Migration
  def change
    add_column :avatars, :input_placeholder, :string    
  end
end
