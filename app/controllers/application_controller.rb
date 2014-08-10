class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
	def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.configuration.admin_user && password == Rails.configuration.admin_password
    end
  end

end
