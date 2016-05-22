require 'socket'
require 'celluloid/current'
require 'celluloid/autostart'

module Actors
  class SocketClient
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Internals::Logger

    attr_reader :host
    attr_reader :port

    attr_reader :topic
    attr_reader :server

    def initialize(host, port, topic)
      @host = host
      @port = port
      @topic = topic
      subscribe topic, :command
      @server = TCPSocket.open(host, port)
    end

    def command(topic, data)
      case data['command']
        when 'H'
          self.send('H')
        when 'L'
          self.send('L')
        else
          # type code here
      end
    end

    def send(string)
      @server.puts(string)
    end
  end
end
