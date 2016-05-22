require 'celluloid/current'
require 'celluloid/autostart'
require 'websocket-eventmachine-server'

module Actors
  class WebServer
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Internals::Logger
    attr_reader :host
    attr_reader :port
    attr_reader :topic

    def initialize(host = '127.0.0.1', port = 9292, topic = 'EventMachine')
      @host = host
      @port = port
      @topic = topic
    end

    def run
      EM.run do
        puts "Server started at port #{port}"
        trap('TERM') { stop }
        trap('INT')  { stop }

        WebSocket::EventMachine::Server.start(:host => @host, :port => @port) do |ws|
          ws.onopen do |handshake|
            puts 'Client Connected!'
            ws.send 'Hello there!'
            data = {}
            data['ws'] = ws
            data['type'] = 'connect'
            publish @topic, data
          end

          ws.onmessage do |msg, type|
            puts "Received message: #{msg}"
            ws.send msg, :type => type
            data = {}
            data['ws'] = ws
            data['type'] = 'message'
            data['msg'] = msg
            publish @topic, data
          end

          ws.onclose do
            puts 'Client disconnected'
            data = {}
            data['ws'] = ws
            data['type'] = 'disconnect'
            publish @topic, data
          end
        end
      end
    end

    def stop
      puts "\nTerminating WebSocket Server"
      EventMachine.stop
      # If we reached this far, safe to stop everything
      puts "\nAllowing 5 seconds for actors to close..."
      sleep(5)
      exit(0)
    end
  end
end
