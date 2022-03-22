require 'sneakers'
require 'json'

class PreMatchReceiverWorker

    include Sneakers::Worker

    from_queue "_4372_",
    exchange: '',
    :exchange_options => {
        :durable => true,
        :passive => true,
        :auto_delete => false
    },
    :queue_options => {
        :durable => true,
        :passive => true,
        :auto_delete => false,
        :manual_ack => false

    }



    def work(payload)

        message = payload#Hash.from_xml(payload)

        threads = []
        threads << Thread.new do
            begin
                connection = Bunny.new(
                 host: "localhost",
                 port: 5672,
                 user: 'skybet',
                 pass: "sky@bet",
                 vhost: "/")
                connection.start

                channel = connection.create_channel
                exchange = channel.topic('odds_feed', durable: true, passive: true)
                queue = channel.queue('skybet',
                  :durable => true, passive:true).bind(exchange, routing_key:"pre_match")

                exchange.publish(message, routing_key:'pre_match')
                puts "[*] Published...#{message}"
                connection.close
            rescue Interrupt => _
                channel.close
                connection.close
            end
        end
        # run all threads
        threads.each { |thr| thr.join }
    end
end
