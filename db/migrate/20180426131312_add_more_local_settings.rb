class AddMoreLocalSettings < ActiveRecord::Migration
  def change
  	add_column :settings, :local_max_char, :string, :default => "Maximum length 80 characters."
	add_column :settings, :local_max_suggest, :string, :default => "Too many submissions. Please wait."
  end
end
