class AddVotingStartTimeToSuggestion < ActiveRecord::Migration
  def change
		add_column :suggestions, :voting_started_at, :string
  end
end
