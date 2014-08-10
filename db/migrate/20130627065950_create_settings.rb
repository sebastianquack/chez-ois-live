class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :redirect_to
      t.integer :redirect

      t.timestamps
    end
  end
end
