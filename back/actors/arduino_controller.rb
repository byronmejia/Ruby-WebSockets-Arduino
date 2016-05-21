require 'serialport'

module Actors
  class ArduinoController
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Internals::Logger
    attr_reader :port_str
    attr_reader :baud_rate
    attr_reader :data_bits
    attr_reader :stop_bits
    attr_reader :parity
    attr_reader :sp

    def initialize
      # The port will change based on: OS, device, etc
      @port_str = '/dev/cu.SLAB_USBtoUART'
      @baud_rate = 9600
      @data_bits = 8
      @stop_bits = 1
      @parity = SerialPort::NONE
      @sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
    end

    def run
      i_old = 0
      while true do
        while (i = @sp.gets.chomp) do
          hash = {}
          unless i_old == i
            hash['text'] = i
            info "ArduinoController: #{i}"
            publish 'Broadcast', hash
          end
          i_old = i
        end
      end

      @sp.close
    end
  end
end
