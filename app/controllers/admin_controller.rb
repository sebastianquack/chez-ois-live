class AdminController < ApplicationController

 	#before_filter :authenticate
	
	def delete_suggestions
		Suggestion.delete_all()
		UserVote.delete_all()
		UserScore.delete_all()
		render json: 'ok'
	end
	
end
