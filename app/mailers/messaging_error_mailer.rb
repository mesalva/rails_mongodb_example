class MessagingErrorMailer < ApplicationMailer
	
	def ranking_error_message(object, error_messsage)
		@object = object
		@error_messsage = error_messsage
		mail(subject: "Error processing ranking object")
	end

end
