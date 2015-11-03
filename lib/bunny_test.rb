require "rubygems"
require "bunny"

conn = Bunny.new
conn.start

ch = conn.create_channel
q  = ch.queue("rankings", :auto_delete => true)
x  = ch.default_exchange

q.subscribe do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end

#x.publish("Hello!", :routing_key => q.name)

#sleep 1.0
#conn.close

#ObjectSpace.define_finalizer(YOUR_RAILS_APP::Application, proc {puts "exiting now"})
 #END { puts "exiting again" } 