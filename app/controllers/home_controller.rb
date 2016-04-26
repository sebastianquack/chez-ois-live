require 'securerandom'

class HomeController < ApplicationController

  before_filter :set_settings
  
  def set_settings
    @first_setting = Setting.first
  end

  def log 
    render :temploate => 'home/log', :layout => 'plain'
  end
  
  def moderate
  end
  
  # iframe views

  def chat
    if params[:user_name] 
      @user_name = params[:user_name]
    else
      @user_name = cookies[:user_name]
      @user_name = "Stammgast" if @user_name.nil?
    end

		params[:avatar_id] = 1 if params[:avatar_id].nil?
		@avatar = Avatar.find_by_id(params[:avatar_id])
    
    @chat_item = ChatItem.order("created_at").last
  end
  
  
end
