class AddTimeoutSettings < ActiveRecord::Migration
  def change
		add_column :settings, :timeout, :integer
  end
end
