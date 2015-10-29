require "rubygems"
require "bunny"

conn = Bunny.new
conn.start

ch = conn.create_channel
q  = ch.queue("rankings", :auto_delete => true)
x  = ch.default_exchange

q.subscribe do |delivery_info, metadata, payload|
  UserRanking.create_or_append(JSON.parse(payload))
end

#sleep 1.0
#at exit {conn.close}