#MESSAGING_SERVICE = MessagingService.new(ENV.fetch("AMQP_URL"))
MESSAGING_SERVICE = MessagingService.new
#MESSAGING_SERVICE.start