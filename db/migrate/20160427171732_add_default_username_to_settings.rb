class AddDefaultUsernameToSettings < ActiveRecord::Migration
  def change
		add_column :settings, :default_username, :string, :default => "Guest"
  end
end
