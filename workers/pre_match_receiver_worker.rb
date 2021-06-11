require 'sneakers'
require 'json'

class PreMatchReceiverWorker

    include Sneakers::Worker

    from_queue "_3537_",
    exchange: '',
    exchange_options => {
        :durable => true
    },
    :queue_options => {
        :durable => true
    }


    def work(payload)

        message = payload#Hash.from_xml(payload)

        connection = Bunny.new(
         host: "localhost",
         port: 5672,
         user: 'skybet',
         pass: "sky@bet",
         vhost: "/")
        connection.start

        channel = connection.create_channel
        exchange = channel.topic('odds_feed', durable: true, passive: true)
        queue = channel.queue('skybet-pre', 
          :durable => true, passive:true).bind(exchange, routing_key:"pre_match")

        begin
            exchange.publish(message, routing_key:'pre_match')
            puts "[*] Published...#{message}"
        rescue Interrupt => _
          channel.close
          connection.close
      end
  end
end