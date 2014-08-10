class CreateSessionVotes < ActiveRecord::Migration
  def change
    create_table :session_votes do |t|
      t.integer :request_id
      t.string :session_id
      t.integer :vote

      t.timestamps
    end
  end
end
