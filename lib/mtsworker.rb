class Mtsworker
   include Sneakers::Worker
   QUEUE_NAME = ""

  from_queue QUEUE_NAME,
   exchange: 'unifiedfeed',
   # exchange_type: :topic,
   :exchange_options => {
      :type => :topic,
      :durable => true,
      :passive => true,
      :auto_delete => false,
   },
   :queue_options => {
      # :durable => false,
      # :auto_delete => false,
      # :exclusive => true,
      # :passive => true
   },
   routing_key: ["*.*.*.*.*.*.*.-.#","*.*.*.*.*.*.*.#{ENV['NODE_ID']}.#"],
   heartbeat: 5

   def work_with_params(payload, delivery_info, metadata)
     
   rescue StandardError => e

      reject!
   end

   
end

