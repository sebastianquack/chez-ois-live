class CreateChatItems < ActiveRecord::Migration
  def change
    create_table :chat_items do |t|
      t.text :content
      t.string :ip_address

      t.timestamps
    end
  end
end
