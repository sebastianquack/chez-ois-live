class AddPlaceIdAvatar < ActiveRecord::Migration
  def up
  	add_column :avatars, :place_id, :integer
		remove_column :avatars, :place
		add_column :places, :name, :string
  end

  def down
  	remove_column :avatars, :place_id
  end
end
