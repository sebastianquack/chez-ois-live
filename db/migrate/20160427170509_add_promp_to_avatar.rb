class AddPrompToAvatar < ActiveRecord::Migration
  def change
    add_column :avatars, :prompt, :string    
  end
end
