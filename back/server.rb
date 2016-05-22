require 'json'

require_relative 'actors/client_collection'
require_relative 'actors/socket_client'
require_relative 'actors/web_server'
require_relative 'actors/arduino_controller'

puts 'Parsing Config...'
config_file = File.read('config/config.json')
config = JSON.parse(config_file)

puts config

clients_actor = Actors::ClientCollection.new(
    config['topics']['webSocket']
)

socket_actor = Actors::SocketClient.new(
    config['arduino']['host'],
    config['arduino']['port'],
    config['arduino']['topic']
)

web_actor = Actors::WebServer.new(
    config['server']['host'],
    config['server']['port'],
    config['topics']['webSocket']
).async.run

puts 'Main file loaded, looping till trap'
loop do
  # nothing
end
