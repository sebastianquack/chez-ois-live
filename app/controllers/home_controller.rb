require 'securerandom'

class HomeController < ApplicationController

	def landing
		@avatars = Avatar.all		
		@user_name = cookies[:user_name]
		@user_name = "Stammgast" if @user_name.nil?

		@settings = Setting.first
		
		if @settings.redirect == 1 && !params[:redirect_off]
			redirect_to @settings.redirect_to
		end

	end

	def play
		@user_hash = cookies[:user_hash]
		@user_hash = cookies.permanent[:user_hash] = SecureRandom.uuid if @user_hash.nil?
		
		@user_name = cookies[:user_name]
		@user_name = "Stammgast" if @user_name.nil?

		params[:place_id] = 1 if params[:place_id].nil?
		@place = Place.find_by_id(params[:place_id])
		
		params[:avatar_id] = 1 if params[:avatar_id].nil?
		@avatar = Avatar.find_by_id(params[:avatar_id])
	end

	def terminal
		@user_hash = cookies[:user_hash]
		@user_hash = cookies.permanent[:user_hash] = SecureRandom.uuid if @user_hash.nil?
		
		@user_name = cookies[:user_name]
		@user_name = "Stammgast" if @user_name.nil?

		@avatars = Avatar.all		
		@avatar = Avatar.find_by_id(params[:avatar_id])
		@place = Place.find_by_id(params[:place_id])

		render :template => 'home/terminal', :layout => 'terminal'
	end
  
  
  # iframe views

  def chat
		@user_name = params[:user_name]
		@user_name = "Stammgast" if @user_name.nil?

		params[:avatar_id] = 1 if params[:avatar_id].nil?
		@avatar = Avatar.find_by_id(params[:avatar_id])
  end

  def pov
		params[:avatar_id] = 1 if params[:avatar_id].nil?
		@avatar = Avatar.find_by_id(params[:avatar_id])
  end

  def highscores
		params[:avatar_id] = 1 if params[:avatar_id].nil?
		@avatar = Avatar.find_by_id(params[:avatar_id])
  end
  
  def test   
		render :template => 'home/test', :layout => 'plain'
  end
  
end
