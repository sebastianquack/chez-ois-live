class RenameRequestTableToSuggestion < ActiveRecord::Migration
	def change
        rename_table :avatar_requests, :suggestions
        rename_column :session_votes, :request_id, :suggestion_id
	end 
end
