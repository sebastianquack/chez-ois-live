class AddLocalizationSettings < ActiveRecord::Migration
  def change
	add_column :settings, :local_initial_greeting, :string, :default => "Hi"
	add_column :settings, :local_name_change_button, :string, :default => "ändern"
	add_column :settings, :local_name_change_prompt, :string, :default => "Wie willst du heißen"    
	add_column :settings, :local_name_change_confirm, :string, :default => "Ok"    
	add_column :settings, :local_suggestion_transmit_notice, :string, :default => "wird übertragen..."    
	add_column :settings, :local_upvote_button, :string, :default => "△ Pro"    
	add_column :settings, :local_downvote_button, :string, :default => "▽ Contra"    
	add_column :settings, :local_upvote_count, :string, :default => "Pros"    
	add_column :settings, :local_downvote_count, :string, :default => "Contras"    
	add_column :settings, :local_text_to_speach_says, :string, :default => "sagt"    
  end
end
