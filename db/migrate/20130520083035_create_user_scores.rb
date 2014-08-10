class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.string :user_name
      t.string :user_hash
      t.integer :score

      t.timestamps
    end
  end
end
