require_relative './client_collection'
require_relative './web_server'
require_relative './arduino_controller'

port = 9292
WebSocketTopic = 'WebSocket'

clients_actor = Actors::ClientCollection.new(WebSocketTopic)
arduino = Actors::ArduinoController.new
web_actor = Actors::WebServer.new(port, WebSocketTopic)
web_actor.async.run
arduino.async.run

puts 'Main file loaded, looping till trap'
loop do
  # nothing
end