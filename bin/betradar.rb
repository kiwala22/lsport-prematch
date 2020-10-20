#!/usr/bin/env ruby
require 'bundler/setup'
root = File.expand_path('../lib', File.dirname(__FILE__))
$: << root
require 'confirm_worker'
require 'reply_worker'
require 'sneakers/runner'
require 'logger'
require 'statsd-ruby'


#statsd = Statsd.new(ENV['STATSD_HOST'], 9125)
#Sneakers.configure(:heartbeat => 5,:amqp => 'amqp://skyline_skyline:EygMKSpVzX9MIUWO@mtsgate-ci.betradar.com:5671',:vhost => '/skyline_skyline',:log  => '/var/www/html/sportsbook/shared/log/sneakers.log', :daemonize => false, :log => STDOUT, :metrics => Sneakers::Metrics::StatsdMetrics.new(statsd))


Sneakers.configure(:heartbeat => 5,:amqp => 'amqp://skyline_skyline:EygMKSpVzX9MIUWO@mtsgate-ci.betradar.com:5671',:vhost => '/skyline_skyline', :daemonize => false, :log => STDOUT)
Sneakers.logger.level = Logger::INFO

r = Sneakers::Runner.new([ ConfirmWorker, ReplyWorker ])
r.run
