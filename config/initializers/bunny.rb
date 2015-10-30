#MESSAGING_SERVICE = MessagingService.new(ENV.fetch("AMQP_URL"))
MESSAGING_SERVICE = MessagingService.new unless Rails.env.test?
#MESSAGING_SERVICE.start