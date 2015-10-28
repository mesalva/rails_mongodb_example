class ValidationException < Exception
	attr_accessor :errors

	def initialize(errors)
		@errors = errors
	end
end