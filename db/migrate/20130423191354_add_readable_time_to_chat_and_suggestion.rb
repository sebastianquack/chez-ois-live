class AddReadableTimeToChatAndSuggestion < ActiveRecord::Migration
  def change
		add_column :suggestions, :time_string, :string
		add_column :chat_items, :time_string, :string  
  end
end
