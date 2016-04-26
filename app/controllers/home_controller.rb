require 'securerandom'

class HomeController < ApplicationController

  before_filter :set_settings
  
  def set_settings
    @first_setting = Setting.first
    
    # user name
    if params[:user_name] 
      @user_name = params[:user_name]
    else
      @user_name = cookies[:user_name]
      @user_name = "Stammgast" if @user_name.nil?
    end

    # avatar
		params[:avatar_id] = 1 if params[:avatar_id].nil?
		@avatar = Avatar.find_by_id(params[:avatar_id])
    
    # moderator notice
    @chat_item = ChatItem.order("created_at").last
    
    @hide_pov = 1 if params[:hide_pov]
    @hide_input = 1 if params[:hide_input]
    @hide_notice = 1 if params[:hide_notice]
  end

  def log 
    render :temploate => 'home/log', :layout => 'plain'
  end
  
  def moderate
    # allow moderation
    @moderate = 1
    render :template => 'home/chat'
  end

  def chat
    # disallow moderation
    @moderate = 0
  end
  
  
end
