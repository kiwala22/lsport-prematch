require 'sneakers'
require 'uri'
require 'net/http'
require 'net/https'

class ConfirmWorker
   log_file = File.open('/var/log/betradar.log', File::WRONLY | File::APPEND)
   @@logger ||= Logger.new(log_file) 
   @@logger.level = Logger::INFO
   
   include Sneakers::Worker
   QUEUE_NAME = "skyline_skyline-Confirm-node202}"
   
   from_queue QUEUE_NAME,
   exchange: 'skyline_skyline-Confirm',
   # exchange_type: :topic,
   :exchange_options => {
      :type => :topic,
      :durable => true,
      :passive => true,
      :auto_delete => false,
   },
   :queue_options => {
      :durable => true,
      # :auto_delete => false,
      # :exclusive => true,
      # :passive => true
   },
   routing_key: ["node202.ticket.confirm"],
   heartbeat: 5
   
   def work_with_params(payload, delivery_info, metadata)
      #extract the routing key
      routing_key = delivery_info[:routing_key]
      
      url = "http://127.0.0.1/amqp/v1/mts/confirm"
      
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 180
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data('payload' => payload, 'routing_key' => routing_key)
      request['access-token'] = "k/GV8prBUWE5D8JEreycbgT+"
      http.set_debug_output($stdout)
      response = http.request(request)
      puts payload
      ack!
   rescue StandardError => e
      #log the error the payload of the message
      puts(e.message)
      puts(e.backtrace.join("\n"))
      reject!
   end
   
   
end

