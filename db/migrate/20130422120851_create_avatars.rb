class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.string :place
      t.string :name
      t.string :pov_stream_embed
      t.timestamps
    end
  end
end
