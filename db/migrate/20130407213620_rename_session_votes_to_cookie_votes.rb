class RenameSessionVotesToCookieVotes < ActiveRecord::Migration
  def change
        rename_table :session_votes, :user_votes
        rename_column :user_votes, :session_id, :user_hash
  end

end
