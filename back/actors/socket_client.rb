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
      subscribe @topic, :new_message
      @server = TCPSocket.open('192.168.4.1')
    end

    def new_message(topic, data)
      info "SocketClient: #{topic}: #{data}"
      self.send(data)
    end

    def send(string)
      @server.puts(string)
    end
  end
end

class SocketClient
  def initialize(server)
    @server = server
  end

  def send(string)
    @server.puts( string )
  end
end

server = TCPSocket.open('192.168.4.1', 1337)
client = SocketClient.new( server )

5.times do
  puts 'LED ON'
  client.send( 'L' )
  sleep(0.5)

  puts 'LED OFF'
  client.send( 'H' )
  sleep(0.5)
end