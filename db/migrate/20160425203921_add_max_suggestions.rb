class AddMaxSuggestions < ActiveRecord::Migration
  def change
		add_column :settings, :num_display_suggestions, :integer, :default => 4
  end
end
