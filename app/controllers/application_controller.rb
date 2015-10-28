class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

  	skip_before_action :verify_authenticity_token

  	before_filter :set_format

  	rescue_from ValidationException, :with => :handle_validation_exception

    def handle_validation_exception(exception)
      render json: {error: exception.errors}.to_json, status: :unprocessable_entity
    end

	def set_format
  		request.format = 'json'
	end
end
