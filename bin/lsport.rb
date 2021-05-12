#!/usr/bin/env ruby
require 'bundler/setup'
root = File.expand_path('../workers', File.dirname(__FILE__))
$: << root
require 'pre_match_receiver_worker'
require 'sneakers/runner'
require 'logger'
require 'statsd-ruby'


Sneakers.configure(
    :amqp => "amqp://acaciabengo%40skylinesms.com:tyb54634@prematch-rmq.lsports.eu:5672",
    :vhost => "Customers",
    :heartbeat => 580,
    :exchange => "",
    :network_recovery_interval => 10,
    :automatically_recover => true,
    :verify_peer => false,
    :verify_peer_name => false,
    :allow_self_signed => false,
    :ack => false,
    :threads => 1,
    :workers => 1,
    :daemonize => false,
    :log => STDOUT
)

Sneakers.logger.level = Logger::INFO

r = Sneakers::Runner.new([ PreMatchReceiverWorker ])
r.run
