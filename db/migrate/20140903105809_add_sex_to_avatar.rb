class AddSexToAvatar < ActiveRecord::Migration
  def change
		add_column :avatars, :gender, :string, :default => "male"
  end
end
