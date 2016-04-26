class AddModeratorToken < ActiveRecord::Migration
  def change
    add_column :settings, :moderator_token, :string, :default => "1ckemod"
  end
end
