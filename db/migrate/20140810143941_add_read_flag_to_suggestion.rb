class AddReadFlagToSuggestion < ActiveRecord::Migration
  def change
		add_column :suggestions, :read, :boolean, :default => false
  end
end
