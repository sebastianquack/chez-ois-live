class DisplaysController < ApplicationController

	def projection
		@avatars = Avatar.all		
		@place = Place.find_by_id(params[:place_id])
		@avatar = Avatar.find_by_id(params[:avatar_id])
		
		render :template => 'displays/index', :layout => 'projection'
	end

	def projection2
		@avatars = Avatar.all		
		@place = Place.find_by_id(params[:place_id])
		@avatar = Avatar.find_by_id(params[:avatar_id])
		
		render :template => 'displays/index2', :layout => 'projection2'
	end

	def hd
		@avatars = Avatar.all		
		@place = Place.find_by_id(params[:place_id])
		@avatar = Avatar.find_by_id(params[:avatar_id])
		
		render :template => 'displays/index', :layout => 'hd'
	end

	def hd2
		@avatars = Avatar.all		
		@place = Place.find_by_id(params[:place_id])
		@avatar = Avatar.find_by_id(params[:avatar_id])
		
		render :template => 'displays/index2', :layout => 'hd2'
	end


end
