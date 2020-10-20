require 'sneakers'
require 'open-uri'
require 'nokogiri'


class Mtsworker
  include Sneakers::Worker
  from_queue 'downloads'

  def work(msg)
    doc = Nokogiri::HTML(open(msg))
    worker_trace "FOUND <#{doc.css('title').text}>"
    ack!
  end
end