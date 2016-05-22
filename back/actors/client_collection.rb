require 'celluloid/current'
require 'celluloid/autostart'

module Actors
  MSG_TYPE = 'messageType'

  CMD_TGL = 'toggle'
  CMD_ON = 'on'
  CMD_OFF = 'off'

  MSG_CMD = 'command'

  PRT_LED = 'led'

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
      case data['type']
        when 'connect'
          # Do Connect
          @clients << data['ws']
        when 'message'
          # Do Message received
          broadcast_command(data)
        when 'disconnect'
          # Do disconnect
          @clients.delete(data['ws'])
      end
    end

    def new_broadcast(topic, data)
      @clients.each do |ws|
        ws.send data['text']
      end
    end

    def broadcast_command(data)
      hash = JSON.parse(data['msg'])
      puts hash
      case hash[MSG_TYPE]
        when MSG_CMD
          publish 'command', hash
        else
          # type code here
      end
    end
  end
end
