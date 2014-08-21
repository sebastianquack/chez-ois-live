class AddPushoverKeyToAvatar < ActiveRecord::Migration
  def change
		add_column :avatars, :pushover_user_key, :string
  end
end
