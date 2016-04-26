class AddCustomCss < ActiveRecord::Migration
  def change
  	add_column :avatars, :custom_css, :string
  	add_column :settings, :custom_css, :string
  end
end
