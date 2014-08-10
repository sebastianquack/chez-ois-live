class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :fix_stream_embed

      t.timestamps
    end
  end
end
