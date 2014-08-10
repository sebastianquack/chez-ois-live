class AddAvatarIdToUserScore < ActiveRecord::Migration
  def change
  	add_column :user_scores, :avatar_id, :integer
  end
end
