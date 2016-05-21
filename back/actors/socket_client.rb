require 'socket'
require 'celluloid/current'
require 'celluloid/autostart'

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

client.send( 'L' )

sleep(2)

client.send( 'H' )

sleep(1)

client.send( 'L' )