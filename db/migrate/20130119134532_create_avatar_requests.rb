class CreateAvatarRequests < ActiveRecord::Migration
  def change
    create_table :avatar_requests do |t|
      t.text :content
      t.string :name
      t.integer :score
      t.integer :status
      t.string :ip_address

      t.timestamps
    end
  end
end
