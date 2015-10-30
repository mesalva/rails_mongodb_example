class MessagingService
  def initialize
    conn = Bunny.new("amqp://guest:guest@localhost:5672")
    conn.start

    ch = conn.create_channel
    @q  = ch.queue("rankings", :auto_delete => true)
    @x  = ch.default_exchange
    at_exit { conn.stop }
  end

  def publish(object)
    @x.publish(object.to_json, :routing_key => @q.name)
  end

end