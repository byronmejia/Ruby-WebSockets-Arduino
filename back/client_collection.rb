require 'celluloid/current'
require 'celluloid/autostart'

module Actors
  class ClientCollection
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Internals::Logger

    attr_reader :topic
    attr_reader :broadcast
    attr_reader :clients

    def initialize(topic = 'EventMachine', broadcast = 'Broadcast')
      @topic = topic
      @broadcast = broadcast
      @clients = []
      info "ClientCollection: Subscribing to: #{@topic}"
      subscribe @topic, :new_message
      subscribe @broadcast, :new_broadcast
    end

    def new_message(topic, data)
      info "ClientCollection: #{topic}: #{data}"
      case data['type']
        when 'connect'
          # Do Connect
          @clients << data['ws']
        when 'message'
          # Do Message received
        when 'disconnect'
          # Do disconnect
          @clients.delete(data['ws'])
      end
    end

    def new_broadcast(topic, data)
      info "ClientCollection: #{topic}: #{data}"
      @clients.each do |ws|
        ws.send data['text']
      end
    end
  end
end
