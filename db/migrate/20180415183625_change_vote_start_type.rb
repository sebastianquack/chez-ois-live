class ChangeVoteStartType < ActiveRecord::Migration
  def change
  	change_column :suggestions, :voting_started_at, 'integer USING CAST(voting_started_at AS integer)'
  end
end
