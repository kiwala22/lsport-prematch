require 'sneakers'

class Mtsworker
  include Sneakers::Worker
   QUEUE_NAME = ""
   
   from_queue QUEUE_NAME,
   exchange: 'skyline_skyline-Confirm-node202',
   # exchange_type: :topic,
   :exchange_options => {
      :type => :topic,
      :durable => true,
      :passive => true,
      :auto_delete => false,
   },
   :queue_options => {
      :durable => false,
      # :auto_delete => false,
      # :exclusive => true,
      # :passive => true
   },
   routing_key: ["node202.ticket.confirm"],
   heartbeat: 5

   def work_with_params(payload, delivery_info, metadata)
      #extract the routing key
      routing_key = delivery_info[:routing_key]

      #extract the sport and message / subject and event
      message = routing_key.split('.')[3]
      sport = routing_key.split('.')[4]
      event = routing_key.split('.')[6]
      
      #convert the xml to a hash
      data = Hash.from_xml(payload)
      #route the messages based on subject, sport and event ID
      puts routing_key
      puts data
      ack!
   rescue StandardError => e
      #log the error the payload of the message
      puts e.message
      puts e.backtrace.join("\n")
      reject!
   end

  
end

