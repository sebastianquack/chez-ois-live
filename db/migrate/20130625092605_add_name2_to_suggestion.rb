class AddName2ToSuggestion < ActiveRecord::Migration
  def change
		add_column :suggestions, :name2, :string
  end
end
