require 'socket'
require 'celluloid/current'
require 'celluloid/autostart'

class SocketClient
  def initialize(server)
    @server = server
    @response = nil
    @request = nil
    listen
    @response.join
  end

  def listen
    @response = Thread.new do
      loop do
        msg = @server.gets.chomp
        puts "#{msg}"
      end
    end
  end
end

server = TCPSocket.open('192.168.4.1', 81)
SocketClient.new( server )