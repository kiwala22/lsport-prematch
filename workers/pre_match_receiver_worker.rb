require 'sneakers'
require 'json'

class PreMatchReceiverWorker
    
    include Sneakers::Worker


    QUEUE_NAME = "_3537_"

    from_queue QUEUE_NAME,
    :queue_options => {
        :passive => true,
        :durable => true
    }


    def work(payload)

        puts "[*] Received #{payload}"

        # Publish Data to AMQP Server when ready

    end
end