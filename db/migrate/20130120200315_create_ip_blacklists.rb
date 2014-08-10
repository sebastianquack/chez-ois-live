class CreateIpBlacklists < ActiveRecord::Migration
  def change
    create_table :ip_blacklists do |t|
      t.string :ip_address
      t.string :user_name
      t.integer :status

      t.timestamps
    end
    add_index :ip_blacklists, :ip_address, :unique => true

  end
end
