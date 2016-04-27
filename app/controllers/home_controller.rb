#require 'securerandom'

class HomeController < ApplicationController

  before_filter :set_settings
  before_filter :authenticate, :only => [:log, :moderate]
  
  def set_settings
    @setting = Setting.first
    
    # user name
    if params[:user_name] 
      @user_name = params[:user_name]
    else
      @user_name = cookies[:user_name]
      @user_name = @setting.default_username if @user_name.nil?
    end

    # avatar
		params[:avatar_id] = 1 if params[:avatar_id].nil?
		@avatar = Avatar.find_by_id(params[:avatar_id])
    
    # moderator notice
    @chat_item = ChatItem.order("created_at").last
    
  end

  def log 
    render :temploate => 'home/log', :layout => 'plain'
  end
  
  def moderate
    
    # allow moderation - todo add password
    @moderate = true
    render :template => 'home/chat'
  end

  def chat
    # disallow moderation
    @moderate = false
  end
  
  
end
