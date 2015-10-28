class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

  	skip_before_action :verify_authenticity_token

  	before_filter :set_format, :cors_preflight_check
  	after_filter :cors_set_access_control_headers

  	rescue_from Exception, :with => :handle_exception

    def handle_exception(exception)
      if exception.is_a?(ValidationException)
      	render json: {error: exception.errors}.to_json, status: :unprocessable_entity
      else
      	render json: {error: exception.message}.to_json, status: :internal_server_error
      end
      
    end

	def set_format
  		request.format = 'json'
	end

	def cors_set_access_control_headers
	    headers['Content-Type'] = 'application/json'
	    headers['Accept'] = 'application/json'
	    headers['Access-Control-Allow-Origin'] = '*'
	    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
	    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
	    headers['Access-Control-Max-Age'] = "1728000"
	end
	 
	def cors_preflight_check
        headers['Content-Type'] = 'application/json'
        headers['Accept'] = 'application/json'
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
        headers['Access-Control-Allow-Headers'] = '*'
        headers['Access-Control-Max-Age'] = '1728000'
	end
end
